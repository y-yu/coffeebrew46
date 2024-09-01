import Foundation

public let weightUnit: String = "g"

// `Timer.scheduledTimer` can handle 0.01 second as minimum time window but
// if we use it the CPU usage will be 95% so `interval` is set bigger value than it.
public let interval = 1.0 / pow(2.0, 5.0)
