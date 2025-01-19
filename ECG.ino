// Define the LED pin (use any GPIO pin on the ESP32)
#define LED_PIN 2  // Onboard LED for some ESP32 boards; change if using an external LED

void setup() {
  // Initialize the LED pin as an output
  pinMode(LED_PIN, OUTPUT);
}

void loop() {
  // Turn the LED on
  digitalWrite(LED_PIN, HIGH);
  delay(1000);  // Wait for 1 second
  
  // Turn the LED off
  digitalWrite(LED_PIN, LOW);
  delay(1000);  // Wait for 1 second
}
