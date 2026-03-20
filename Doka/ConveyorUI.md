# ConveyorUI

**Тип:** Node  
**Файл:** `conveyor_ui.gd`  
**Наследует:** CanvasLayer

## Описание
Главный управляющий UI конвейера. Соединяет между собой [[GarbageConveyor]] и [[GarbageUI]] — слушает сигналы конвейера и реагирует на кнопки в UI. Создаётся и инициализируется самим конвейером или сценой.

Выступает посредником: конвейер не знает про UI, UI не знает про конвейер — `ConveyorUI` знает про обоих.

## Зависимости
- [[GarbageConveyor]] — конвейер за которым следит
- [[GarbageUI]] — панель с информацией о предмете и кнопками
- [[ItemInstance]] — получает от конвейера для передачи в UI

## Переменные

| Имя                  | Тип             | Описание                                |
| -------------------- | --------------- | --------------------------------------- |
| _conveyor            | GarbageConveyor | конвейер, назначается через `init()`    |
| _garbage_ui          | GarbageUI       | панель предмета, создаётся в `init()`   |
| GARBAGE_UI_SCENE     | PackedScene     | сцена GarbageUI                         |


## Методы

### init(conveyor)
Инициализирует UI под конкретный конвейер. Подключает все нужные сигналы и создаёт дочерний [[GarbageUI]].

Подключения:
- `conveyor.item_spawned` → `_on_item_spawned`
- `conveyor.item_cleared` → `_on_item_cleared`
- `conveyor.interaction_zone.player_entered` → `_on_player_entered`
- `conveyor.interaction_zone.player_exited` → `_on_player_exited`
- `_garbage_ui.burn_pressed` → `_on_burn_pressed`
- `_garbage_ui.take_pressed` → `_on_take_pressed`

---

### _on_item_spawned(instance)
Реагирует на появление нового предмета на конвейере. Если игрок уже стоит в зоне — сразу показывает панель с данными предмета.

---

### _on_item_cleared()
Реагирует на уборку предмета с конвейера — прячет панель.

---

### _on_player_entered()
Игрок вошёл в зону конвейера. Если предмет уже есть — показывает панель.

---

### _on_player_exited()
Игрок вышел из зоны — прячет панель.

---

### _on_burn_pressed()
Вызывает `_conveyor.burn()`.

---

### _on_take_pressed()
Вызывает `_conveyor.take()`.

---

## Используется в
- `GarbageConveyor.tscn` или `Scene.tscn`
