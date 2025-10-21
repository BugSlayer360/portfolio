// Daniel Shiffman
// Example 10-5 Timer

class Timer {

  int savedTime; // When Timer started
  int totalTime; // How long Timer should last
  boolean running;

  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
    running = true;
    savedTime = millis();
  }

  // Start or restart the timer
  void start() {
    savedTime = millis();
    running = true;
  }
  
  // Stop the timer manually
  void stop() {
    running = false;
  }

  // Check if timer is finished
  boolean isFinished() {
    if (!running) return false;  // if stopped, never finishes

    int passedTime = millis() - savedTime;
    return passedTime > totalTime;
  }
}

