
// Для процедуры ВыполнитьОбновлениеДоступа.
// Возвращаемое значение:
//  ТаблицаЗначений:
//   * ЕстьТочечноеЗадание - Булево
//   * ЕстьНачальноеОбновлениеТочечногоЗадания - Дата
//   * ДатаПоследнегоЗапускаТочечногоЗадания - Дата
//   * ДатаДобавленияТочечногоЗадания - Дата
//   * УровеньЗависимости - Число
//   * ЗависимыеСписки - Массив
//                     - Строка
//   * ЕстьНачальноеОбновление - Булево
//   * ЕстьПерезапуск - Булево
//   * ДатаПоследнегоЗапускаОбщегоЗадания - Дата
//   * ЕстьДатаПоследнегоОбновленногоЭлемента - Булево
//   * ДатаПоследнегоОбновленногоЭлемента - Дата
//   * ДатаДобавленияОбщегоЗадания - Дата
//   * ИдентификаторСписка - СправочникСсылка.ИдентификаторыОбъектовМетаданных
//                         - СправочникСсылка.ИдентификаторыОбъектовРасширений
//   * ДляВнешнихПользователей - Булево
//   * ЭтоОбновлениеПрав - Булево
//   * Запускать - Булево
//   * ЗанятыеПотоки - Соответствие из КлючИЗначение:
//      ** Ключ - УникальныйИдентификатор
//      ** Значение - см. НовыйПоток
//   * НаборПорций - Массив из см. ПорцияИзНабора
//   * КоличествоПорцийДляОбработки - Число
//   * ИндексСледующейПорцииДляОбработки - Число
//   * Пропустить - Булево
//   * Удалить - Булево
//   * ПорядокВидаКлючаДанных - Число
//   * ЭтоОбработкаУстаревшихЭлементов - Булево
//   * ОбновитьУровеньЗависимости - Булево
// 
Функция ТаблицаЗаданийОбновления()
	
	ТипыИдентификаторов = Новый Массив;
	
КонецФункции

// Возвращаемое значение:
//  Структура:
//   * ОписаниеОсновногоСеанса - см. ОписаниеОсновногоСеанса
//   * ТекущееФоновоеЗадание - ФоновоеЗадание
//   * Задания - см. ТаблицаЗаданийОбновления
//   * ЗаданияДляЗапуска - Массив из СтрокаТаблицыЗначений: см. ТаблицаЗаданийОбновления
//   * ЗаданияДляЗапуска1 - Массив из Структура: см. ТаблицаЗаданийОбновления
//   * ЗанятыеПотоки - Соответствие из КлючИЗначение:
//      ** Ключ - УникальныйИдентификатор
//      ** Значение - см. НовыйПоток
//   * СвободныеПотоки - Массив из см. НовыйПоток
//   * ГраницаОбновленияЗаданий - Дата
//   * ОбщиеПараметрыОбновления - см. ОписаниеОбщихПараметровОбновления
//   * ОбновлениеВЭтомСеансе - Булево
//   * КоличествоПотоков - Число
//   * ДатаПолногоЗавершения - Дата
//   * ТекстОшибкиЗавершения - Строка
//   * ЕстьОтложенныеЗадания - Булево
//   * ЕстьЗапущенноеЗадание - Булево
//   * ОбработкаЗавершена - Булево
//   * ОбновлениеОтменено - Булево
//   * ТребуетсяПерезапускСеанса - Булево
//   * МаксимумПорцийИзИсходной - Число
//   * КоличествоДополнительныхПорций - Число
//   * ЕстьДлительноеЗаданиеПолученияПорцийЭлементовДанных - Булево
//   * МаксимальноеКоличествоСекундБыстрогоПолученияПорцийЭлементовДанных - Число
//   * ИдентификаторыОтключенныхОбъектовМетаданных - Соответствие
//   * ИдентификаторСправочникаНаборыГруппДоступа - СправочникСсылка.ИдентификаторыОбъектовМетаданных
//
Функция НовыйКонтекстОбновленияДоступа()
	
	Возврат Новый Структура;
	
КонецФункции
