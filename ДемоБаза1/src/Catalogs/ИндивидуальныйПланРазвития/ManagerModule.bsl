///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии ...
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Владелец)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Ученический договор
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Справочник.ИндивидуальныйПланРазвития";
	КомандаПечати.Идентификатор = "ИндивидуальныйПланРазвития";
	КомандаПечати.Представление = НСтр("ru = 'Индивидуальный план развития'");
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ИндивидуальныйПланРазвития");
	Если НужноПечататьМакет Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ИндивидуальныйПланРазвития",
			НСтр("ru = 'Индивидуальный план развития'"),
			ПечатьИПР(МассивОбъектов, ОбъектыПечати),
			,
			"Справочник.ИндивидуальныйПланРазвития.ПФ_MXL_ИндивидуальныйПланРазвития");
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьИПР(МассивОбъектов, ОбъектыПечати)
	
	// Создаем табличный документ и устанавливаем имя параметров печати.
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ИПР";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.ИндивидуальныйПланРазвития.ПФ_MXL_ИндивидуальныйПланРазвития");
	ОбластьМакетаШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакетаСтрокаМероприятия = Макет.ПолучитьОбласть("СтрокаМероприятия");
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
		  "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		  |	ИндивидуальныйПланРазвития.Ссылка КАК ПланСсылка,
		  |	ИндивидуальныйПланРазвития.Владелец КАК Сотрудник,
		  |	ИндивидуальныйПланРазвития.Ответственный.ФизическоеЛицо КАК СотрудникКадровойСлужбы,
		  |	ИндивидуальныйПланРазвития.ДатаНачала КАК ДатаНачалаИПР,
		  |	ИндивидуальныйПланРазвития.ДатаОкончания КАК ДатаОкончанияИПР,
		  |	ИндивидуальныйПланРазвития.Подразделение КАК Подразделение,
		  |	ИндивидуальныйПланРазвития.РекомендацииРазвития КАК РекомендацииРазвития,
		  |	ИндивидуальныйПланРазвитияМероприятия.Мероприятие.Представление КАК Мероприятие,
		  |	ИндивидуальныйПланРазвитияМероприятия.ДатаНачала КАК ДатаНачала,
		  |	ИндивидуальныйПланРазвитияМероприятия.ДатаОкончания КАК ДатаОкончания,
		  |	ИндивидуальныйПланРазвитияМероприятия.РезультатВыполнения КАК РезультатВыполнения,
		  |	ИндивидуальныйПланРазвитияМероприятия.Ответственный КАК Ответственный
		  |ПОМЕСТИТЬ ИПР
		  |ИЗ
		  |	Справочник.ИндивидуальныйПланРазвития.Мероприятия КАК ИндивидуальныйПланРазвитияМероприятия
		  |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ИндивидуальныйПланРазвития КАК ИндивидуальныйПланРазвития
		  |		ПО ИндивидуальныйПланРазвитияМероприятия.Ссылка = ИндивидуальныйПланРазвития.Ссылка
		  |ГДЕ
		  |	ИндивидуальныйПланРазвития.Ссылка В(&МассивОбъектов)
		  |;
		  |
		  |////////////////////////////////////////////////////////////////////////////////
		  |ВЫБРАТЬ
		  |	ИПР.Сотрудник КАК ФизическоеЛицо,
		  |	ИПР.ДатаНачалаИПР КАК Период
		  |ПОМЕСТИТЬ ВТСотрудники
		  |ИЗ
		  |	ИПР КАК ИПР
		  |
		  |ОБЪЕДИНИТЬ ВСЕ
		  |
		  |ВЫБРАТЬ РАЗЛИЧНЫЕ
		  |	ИПР.СотрудникКадровойСлужбы,
		  |	ИПР.ДатаНачалаИПР
		  |ИЗ
		  |	ИПР КАК ИПР";
		
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Выполнить();
	
	// Получение кадровых данных сотрудника.
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеФизическихЛиц(
		Запрос.МенеджерВременныхТаблиц,
		"ВТСотрудники");
	КадровыеДанные = "ФИОПолные,ФамилияИО";
	КадровыйУчет.СоздатьВТКадровыеДанныеФизическихЛиц(ОписательВременныхТаблиц, Истина, КадровыеДанные);
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИПР.ПланСсылка КАК ПланСсылка,
		|	ИПР.Сотрудник КАК Сотрудник,
		|	ИПР.СотрудникКадровойСлужбы КАК СотрудникКадровойСлужбы,
		|	ИПР.ДатаНачалаИПР КАК ДатаНачалаИПР,
		|	ИПР.ДатаОкончанияИПР КАК ДатаОкончанияИПР,
		|	ИПР.Подразделение КАК Подразделение,
		|	ИПР.РекомендацииРазвития КАК РекомендацииРазвития,
		|	ИПР.Мероприятие КАК Мероприятие,
		|	ИПР.ДатаНачала КАК ДатаНачала,
		|	ИПР.ДатаОкончания КАК ДатаОкончания,
		|	ИПР.Ответственный КАК Ответственный,
		|	ВТКадровыеДанныеФизическихЛиц.ФИОПолные КАК ФИОСотрудника,
		|	ВТКадровыеДанныеФизическихЛиц.ФамилияИО КАК ФамилияИОСотрудника,
		|	ВТКадровыеДанныеФизическихЛицКадровыйСотрудник.ФИОПолные КАК ФИОСотрудникаКадровойСлужбы,
		|	ВТКадровыеДанныеФизическихЛицКадровыйСотрудник.ФамилияИО КАК ФамилияИОСотрудникаКадровойСлужбы
		|ИЗ
		|	ИПР КАК ИПР
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеФизическихЛиц КАК ВТКадровыеДанныеФизическихЛиц
		|		ПО ИПР.Сотрудник = ВТКадровыеДанныеФизическихЛиц.ФизическоеЛицо
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеФизическихЛиц КАК ВТКадровыеДанныеФизическихЛицКадровыйСотрудник
		|		ПО ИПР.СотрудникКадровойСлужбы = ВТКадровыеДанныеФизическихЛицКадровыйСотрудник.ФизическоеЛицо
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПланСсылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.СледующийПоЗначениюПоля("ПланСсылка") Цикл
		ЗаполнитьЗначенияСвойств(ОбластьМакетаШапка.Параметры, Выборка);
		
		ОбластьМакетаШапка.Параметры.ДатаНачалаИПР = Формат(Выборка.ДатаНачалаИПР, "ДЛФ=D");
		ОбластьМакетаШапка.Параметры.ДатаОкончанияИПР = Формат(Выборка.ДатаОкончанияИПР, "ДЛФ=D");
		
		ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
		
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(ОбластьМакетаСтрокаМероприятия.Параметры, Выборка);
			ОбластьМакетаСтрокаМероприятия.Параметры.ДатаНачала = Формат(Выборка.ДатаНачала, "ДЛФ=D");
			ОбластьМакетаСтрокаМероприятия.Параметры.ДатаОкончания = Формат(Выборка.ДатаОкончания, "ДЛФ=D");
			ОбластьМакетаСтрокаМероприятия.Параметры.Ответственный = 
			
			ТабличныйДокумент.Вывести(ОбластьМакетаСтрокаМероприятия);
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#КонецЕсли