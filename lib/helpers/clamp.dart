int clamp(int num, int min, int max) {
  if (num < min) {
    return min;
  } else if (num > max) {
    return max;
  }
  return num;
}
