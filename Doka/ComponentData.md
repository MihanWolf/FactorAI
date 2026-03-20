# ComponentData

**Тип:** Resource  
**Файл:** `component_data.gd`  
**Наследует:** Resource

## Описание
Чертёж компонента — описывает что такое "Советский корпус" или "Обычные провода" в общем виде. Один ресурс на весь тип компонента, хранится в `.tres` файле и регистрируется в [[ComponentDatabase]].

Не путать с [[ComponentInstance]] — это конкретный корпус с потёртостями и зелёным цветом, а `ComponentData` это просто описание "что такое корпус вообще".

## Зависимости
Ни от каких других классов проекта не зависит — это чистый фундаментальный ресурс.

## Переменные

| Имя | Тип | Описание |
|-----|-----|----------|
| component_name | String | название компонента |
| component_type | ComponentType | тип из enum ниже |
| compatible_items | Array[String] | теги совместимости, например ["radio", "electronics"] — задел на будущее |
| sprite_layers | Array[Texture2D] | слои спрайта (base, overlay, detail) для послойной отрисовки |
| color_regions | Array[String] | названия регионов которые можно перекрашивать |
| base_weight | float | базовый вес, влияет на вес предмета — задел на будущее |
| base_value | float | базовая ценность — задел на будущее |

## Enum ComponentType

Живёт внутри `ComponentData`, поэтому везде в коде пишется как `ComponentData.ComponentType`.

| Значение | Описание |
|----------|----------|
| CHASSIS | корпус |
| CIRCUIT | плата |
| WIRE | провода |
| SPEAKER | динамик |
| POWER | источник питания |
| LENS | линза / стекло |
| FASTENER | крепёж (болты, винты) |

## Используется в
- [[ComponentInstance]]
- [[ComponentSlotData]]
- [[ComponentDatabase]]
