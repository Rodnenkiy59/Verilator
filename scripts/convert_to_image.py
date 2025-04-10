from PIL import Image
import os

# Параметры изображения
WIDTH = 1600  # Ширина в пикселях
HEIGHT = 480  # Высота в пикселях
BYTES_PER_PIXEL = 3  # 24 бита = 3 байта (RGB)

def create_image_from_file(input_file, output_image):
    # Проверяем размер файла
    file_size = os.path.getsize(input_file)
    expected_size = WIDTH * HEIGHT * BYTES_PER_PIXEL
    
    # if file_size != expected_size:
    #     raise ValueError(f"Размер файла ({file_size} байт) не соответствует ожидаемому ({expected_size} байт) для 480x800 пикселей с 24 битами")

    # Создаем новое изображение в режиме RGB
    img = Image.new('RGB', (WIDTH, HEIGHT))
    pixels = img.load()  # Доступ к пикселям

    # Читаем файл
    with open(input_file, 'rb') as f:
        for y in range(HEIGHT):
            for x in range(WIDTH):
                # Читаем 3 байта для каждого пикселя (RGB)
                r = ord(f.read(1))  # Красный
                g = ord(f.read(1))  # Зелёный
                b = ord(f.read(1))  # Синий
                pixels[x, y] = (r, g, b)  # Устанавливаем цвет пикселя

    # Сохраняем изображение
    img.save(output_image)
    print(f"Изображение успешно сохранено как {output_image}")

def main():
    input_file = "pixel_data.bin"  # Имя входного файла
    output_image = "output.png"    # Имя выходного изображения
    
    try:
        create_image_from_file(input_file, output_image)
    except FileNotFoundError:
        print(f"Ошибка: Файл {input_file} не найден")
    except ValueError as e:
        print(f"Ошибка: {e}")
    except Exception as e:
        print(f"Произошла ошибка: {e}")

if __name__ == "__main__":
    main()