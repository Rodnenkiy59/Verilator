import os

# Параметры изображения
WIDTH = 800  # Ширина в пикселях
HEIGHT = 480  # Высота в пикселях
BYTES_PER_PIXEL = 3  # 24 бита = 3 байта (RGB)

def generate_test_file(filename):
    with open(filename, 'wb') as f:
        for y in range(HEIGHT):
            for x in range(WIDTH):
                # Пример: градиент
                r = x % 256  # Красный зависит от x
                g = y % 256  # Зелёный зависит от y
                b = (x + y) % 256  # Синий зависит от суммы
                f.write(bytes([r, g, b]))

# Создаем тестовый файл
generate_test_file("pixel_data.bin")