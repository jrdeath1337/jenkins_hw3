"""
Простой калькулятор с базовыми арифметическими операциями.
"""

def add(a, b):
    """Возвращает сумму a и b."""
    return a + b

def subtract(a, b):
    """Возвращает разность a и b."""
    return a - b

def multiply(a, b):
    """Возвращает произведение a и b."""
    return a * b

def divide(a, b):
    """
    Возвращает частное a и b.
    При делении на ноль выбрасывает исключение ValueError.
    """
    if b == 0:
        raise ValueError("Деление на ноль недопустимо")
    return a / b
