#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>

#define ULP_SERVICE_UUID          "F278E33F-D8F1-4F4B-8E04-885A5968FA11"

#define USER_NAME_UUID            "4FB34DCC-27AB-4D22-AB77-9E3B03489CFC"
#define USER_ID_UUID              "2D58B503-FE42-4010-BA8D-3F6A7632FCD5"
#define USER_LED_UUID             "6067DAB3-D8C0-4D82-A486-C7499176B57A"

#define DEVINFO_UUID              (uint16_t)0x180a
#define DEVINFO_MANUFACTURER_UUID (uint16_t)0x2a29
#define DEVINFO_NAME_UUID         (uint16_t)0x2a24
#define DEVINFO_SERIAL_UUID       (uint16_t)0x2a25

#define DEVICE_MANUFACTURER       "ULP"
#define DEVICE_NAME               "ULP Demo Device"

#define PIN_LED 2

LiquidCrystal_I2C lcd(0x27,2,1,0,4,5,6,7,3,POSITIVE);

BLECharacteristic *pCharacteristicUserName;
BLECharacteristic *pCharacteristicUserId;
BLECharacteristic *pCharacteristicUserLED;

bool connected = false;
bool displayRefresh = true;

String userName = "";
String userId = "";
bool userLED = false;

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      Serial.println("Connected");
      connected = true;
      displayRefresh = true;
    };

    void onDisconnect(BLEServer* pServer) {
      Serial.println("Disconnected");
      connected = false;

      userName = "";
      userId = "";
      userLED = false;

      displayRefresh = true;
    }
};

class UserNameCallbacks: public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    std::string value = pCharacteristic->getValue();
    userName = String(value.c_str());
    displayRefresh = true;
  }
};

class UserIdCallbacks: public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    std::string value = pCharacteristic->getValue();
    userId = String(value.c_str());
    displayRefresh = true;
  }
};

class UserLEDCallbacks: public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    std::string value = pCharacteristic->getValue();
    if (value.length()  == 1) {
        uint8_t v = value[0];
        userLED = v ? 1 : 0;
        displayRefresh = true;
    }
  }
};

void setup() {
  Serial.begin(115200);
  Serial.println("Starting...");
  
  lcd.begin(16,2);

  pinMode(PIN_LED, OUTPUT);

  String devName = DEVICE_NAME;
  String chipId = String((uint32_t)(ESP.getEfuseMac() >> 24), HEX);
  devName += " (";
  devName += chipId;
  devName += ')';

  BLEDevice::init(devName.c_str());
  BLEServer *pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());


  BLEService *pService = pServer->createService(ULP_SERVICE_UUID);

  pCharacteristicUserName = pService->createCharacteristic(USER_NAME_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE);
  pCharacteristicUserName->setCallbacks(new UserNameCallbacks());

  pCharacteristicUserId = pService->createCharacteristic(USER_ID_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE);
  pCharacteristicUserId->setCallbacks(new UserIdCallbacks());
  
  pCharacteristicUserLED = pService->createCharacteristic(USER_LED_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE);
  pCharacteristicUserLED->setCallbacks(new UserLEDCallbacks());
  

  pService->start();

  pService = pServer->createService(DEVINFO_UUID);

  BLECharacteristic *pChar = pService->createCharacteristic(DEVINFO_MANUFACTURER_UUID, BLECharacteristic::PROPERTY_READ);
  pChar->setValue(DEVICE_MANUFACTURER);

  pChar = pService->createCharacteristic(DEVINFO_NAME_UUID, BLECharacteristic::PROPERTY_READ);
  pChar->setValue(DEVICE_NAME);

  pChar = pService->createCharacteristic(DEVINFO_SERIAL_UUID, BLECharacteristic::PROPERTY_READ);
  pChar->setValue(chipId.c_str());

  pService->start();


  BLEAdvertising *pAdvertising = pServer->getAdvertising();

  BLEAdvertisementData adv;
  adv.setName(devName.c_str());
  //adv.setCompleteServices(BLEUUID(SERVICE_UUID));
  pAdvertising->setAdvertisementData(adv);

  BLEAdvertisementData adv2;
  //adv2.setName(devName.c_str());
  adv2.setCompleteServices(BLEUUID(ULP_SERVICE_UUID));
  pAdvertising->setScanResponseData(adv2);

  pAdvertising->start();

  Serial.println("Ready");
  Serial.print("Device name: ");
  Serial.println(devName);
}

void echo(String first, String second) {
  lcd.home();
  lcd.print(first);
  lcd.setCursor ( 0, 1 );
  lcd.print(second);
}

void loop() {
  if (displayRefresh) {
    lcd.clear();

    if (connected) {
      digitalWrite(PIN_LED, userLED ? 1 : 0);
      lcd.home();
      lcd.print("Hi, " + userName + "!");
      lcd.setCursor(0, 1);
      lcd.print("ID: " + userId.substring(0,7) + userId.substring(39, 44)); // 000615.d7814f22f99b4de3b395158c77848412.1933
    } else {
      echo("Device (" + String((uint32_t)(ESP.getEfuseMac() >> 24), HEX) + ")", "Ready to connect");
    }

    displayRefresh = false;
  }
}
