import serial
import time

# Specify the serial port and baud rate
serial_port = 'COM8'  # Change this to the port where your Arduino is connected
baud_rate = 9600      # Must match the baud rate in the Arduino code
output_file = "ecg_data.txt"

def save_ecg_data():
    try:
        # Open the serial connection
        with serial.Serial(serial_port, baud_rate, timeout=1) as ser:
            print(f"Connected to {serial_port} at {baud_rate} baud")
            
            # Open the file for writing
            with open(output_file, 'w') as file:
                print(f"Saving data to {output_file}. Press Ctrl+C to stop.")
                
                # Allow some time for Arduino to initialize
                time.sleep(2)
                
                while True:
                    # Read a line of data from the serial port
                    line = ser.readline().decode('utf-8').strip()
                    
                    if line:
                        # Write the data to the file
                        file.write(line + '\n')
                        print(line)  # Optionally display the data in the terminal
    except KeyboardInterrupt:
        print("\nData saving stopped by user.")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        print(f"Data saved to {output_file}.")

if __name__ == "__main__":
    save_ecg_data()
