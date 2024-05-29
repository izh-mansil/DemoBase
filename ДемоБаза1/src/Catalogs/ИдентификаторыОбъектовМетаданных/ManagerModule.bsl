///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии ...
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Предотвращает недопустимое изменение идентификаторов объектов метаданных.
// Выполняет обработку дублей подчиненного узла распределенной информационной базы.
//
Процедура ПередЗаписьюОбъекта(Объект) Экспорт
	
	// Отключение механизма регистрации объектов.
	Объект.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
	
	// Регистрация объекта на всех узлах РИБ.
	Для Каждого ПланОбмена Из Метаданные.ПланыОбмена Цикл
		//ЗарегистрироватьОбъектНаВсехУзлах(Объект, ПланОбмена, Ложь);
	КонецЦикла;
	
	Если Объект.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	//ПроверитьОбъектПередЗаписью(Объект);
	
КонецПроцедуры

// Предотвращает удаление идентификаторов объектов метаданных не помеченных на удаление.
Процедура ПередУдалениемОбъекта(Объект) Экспорт
	
	//ОбъектыРасширений = ЭтоОбъектРасширений(Объект);
	//СтандартныеПодсистемыПовтИсп.ИдентификаторыОбъектовМетаданныхПроверкаИспользования(, ОбъектыРасширений);
	
	// Отключение механизма регистрации объектов.
	// Ссылки идентификаторов удаляются независимо во всех узлах
	// через механизм пометки удаления и удаления помеченных объектов.
	//Объект.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
	
	Если Объект.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Объект.ПометкаУдаления Тогда
		ВызватьИсключение 
			НСтр("ru = 'Удаление идентификаторов объектов, у которых значение
			           |реквизита ""Пометка удаления"" установлено Ложь недопустимо.'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли