# ComponentDatabase

**Тип:** Resource  
**Файл:** `component_database.gd`  
**Наследует:** Resource

## Описание
Реестр всех компонентов в игре. Хранит список [[ComponentData]] ресурсов и умеет строить из них пул для генерации предметов. Назначается в инспекторе там где нужна генерация — например в [[GarbageConveyor]].

## Зависимости
- [[ComponentData]] — хранит массив этих ресурсов

## Переменные

| Имя | Тип | Описание |
|-----|-----|----------|
| components | Array[ComponentData] | все компоненты в игре |

## Методы

### build_pool() -> Dictionary
Строит словарь `ComponentType → Array[ComponentData]` из плоского списка компонентов. Результат удобно передавать в [[ItemInstance]].create_random() чтобы тот мог быстро найти компоненты нужного типа.

Пример результата:
```
{
  CHASSIS: [ComponentData("Советский корпус"), ComponentData("Стальной корпус")],
  WIRE:    [ComponentData("Обычные провода")],
}
```

## Используется в
- [[GarbageConveyor]]
