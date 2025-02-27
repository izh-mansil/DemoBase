///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии ...
///////////////////////////////////////////////////////////////////////////////////////////////////////

Функция ВыборкаИзЗапросаРасчетаСтатусовУказанияСерий(ПараметрыУказанияСерий,
													ТаблицаТовары,
													ТаблицаСерии,
													Склад, //Если склады в ТЧ, то параметр игнорируется
													СтрокиТоваровДляОбработки = Неопределено,
													СтрокиСерийДляОбработки = Неопределено)
	
	//МодульМенеджера = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПараметрыУказанияСерий.ПолноеИмяОбъекта);
	//
	//ТекстЗапроса = МодульМенеджера.ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий);
	
	//Запрос = Новый Запрос;
	//Запрос.Текст = ТекстЗапроса;
	//
	//Если ТипЗнч(Склад) = Тип("Структура") Тогда
	//	Запрос.УстановитьПараметр("СкладОтправитель", Склад.Отправитель);
	//	Запрос.УстановитьПараметр("СкладПолучатель", Склад.Получатель);
	//Иначе
	//	Запрос.УстановитьПараметр("Склад", Склад);
	//	Запрос.УстановитьПараметр("СкладОтправитель", Склад);
	//	Запрос.УстановитьПараметр("СкладПолучатель", Склад);
	//КонецЕсли;
	//
	////УстановитьПараметрыЗапросаПоПараметрамУказанияСерий(Запрос,ПараметрыУказанияСерий);
	//
	//Если ТипЗнч(ТаблицаТовары) = Тип("ТаблицаЗначений") Тогда
	//	ТаблицаТоварыПараметрЗапроса = ТаблицаТовары;
	//Иначе
	//	Если СтрокиТоваровДляОбработки <> Неопределено Тогда
	//		ТаблицаТоварыПараметрЗапроса = ТаблицаТовары.Выгрузить(СтрокиТоваровДляОбработки);
	//	Иначе
	//		ТаблицаТоварыПараметрЗапроса = ТаблицаТовары.Выгрузить();
	//	КонецЕсли;
	//КонецЕсли;
	//
	//Если ТипЗнч(ТаблицаСерии) = Тип("ТаблицаЗначений") Тогда
	//	ТаблицаСерииПараметрЗапроса = ТаблицаСерии;
	//Иначе
	//	Если СтрокиСерийДляОбработки <> Неопределено Тогда
	//		ТаблицаСерииПараметрЗапроса = ТаблицаСерии.Выгрузить(СтрокиСерийДляОбработки);
	//	Иначе
	//		ТаблицаСерииПараметрЗапроса = ТаблицаСерии.Выгрузить();
	//	КонецЕсли;
	//КонецЕсли;
	//
	// Запрос.УстановитьПараметр("Товары", ТаблицаТоварыПараметрЗапроса);
	//Запрос.УстановитьПараметр("Серии", ТаблицаСерииПараметрЗапроса);
	//
	// УстановитьПривилегированныйРежим(Истина); // В перемещении товаров один из складов может быть недоступен пользователю
	//
	//Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

Процедура ПроверкаИнструкцийПрепроцессора(ПараметрыУказанияСерий, ТаблицаТоваров, ТаблицаСерий, Склад)
	
	#Если Сервер Тогда
		
	#КонецЕсли
	
	#Если Клиент Тогда
		
	#КонецЕсли
	
	Выборка = ВыборкаИзЗапросаРасчетаСтатусовУказанияСерий(ПараметрыУказанияСерий, ТаблицаТоваров, ТаблицаСерий, Склад);
	
КонецПроцедуры

Процедура фывафыва(ОбменДанными, а) Экспорт 
	
	Если ОбменДанными.Загрузка И Истина Тогда 
		
		Возврат;
		
	КонецЕсли;
	
	Пособия = "";
	
	//Запрос = Новый Запрос;
	//
	//Запрос.Текст = "
	//	|ТОГДА "" ""По временной нетрудоспособности в связи с несчастными случаями на производстве, "" "" ИНАЧЕ ""ывафывафыа"" " + Пособия.ОписаниеВидаЗанятости;
	//	а = "|ТОГДА """" ";
	
КонецПроцедуры

// Проверяет корректность параметров администрирования.
//
// Параметры:
//  ПараметрыАдминистрированияКластера - см. АдминистрированиеКластераКлиентСервер.ПараметрыАдминистрированияКластера
//  ПараметрыАдминистрированияИБ - см. АдминистрированиеКластераКлиентСервер.ПараметрыАдминистрированияИнформационнойБазыКластера
//  ПроверятьПараметрыАдминистрированияКластера - Булево - флаг необходимости проверки параметров администрирования кластера,
//  ПроверятьПараметрыАдминистрированияИнформационнойБазы - Булево - флаг необходимости проверки параметров
//      администрирования кластера.
//
Процедура ПроверитьПараметрыАдминистрирования(Знач ПараметрыАдминистрированияКластера, Знач ПараметрыАдминистрированияИБ = Неопределено,
	ПроверятьПараметрыАдминистрированияКластера = Истина,
	ПроверятьПараметрыАдминистрированияИнформационнойБазы = Истина) Экспорт
	
	Если ПараметрыАдминистрированияИБ = Неопределено Тогда
		ПараметрыАдминистрированияИБ = ПараметрыАдминистрированияКластера;
	КонецЕсли;
	
	//МенеджерАдминистрирования = МенеджерАдминистрирования(ПараметрыАдминистрированияКластера);
	//МенеджерАдминистрирования.ПроверитьПараметрыАдминистрирования(ПараметрыАдминистрированияКластера, ПараметрыАдминистрированияИБ, ПроверятьПараметрыАдминистрированияИнформационнойБазы, ПроверятьПараметрыАдминистрированияКластера);
	
КонецПроцедуры

Процедура ЗаполнитьНаборыЗначенийДоступаТабличныхЧастей(Источник, Отказ = Неопределено, РежимЗаписи = Неопределено, РежимПроведения = Неопределено) Экспорт
	
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
	//	МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
	//	МодульУправлениеДоступом.ЗаполнитьНаборыЗначенийДоступаТабличныхЧастей(Источник, Отказ, РежимЗаписи, РежимПроведения);
	//КонецЕсли;
	
КонецПроцедуры

Процедура ПодписатьФайл(ПрисоединенныйФайл, ИдентификаторФормы, ДополнительныеПараметры = Неопределено) Экспорт
	
	ОбщегоНазначения.ПодписатьФайл(ПрисоединенныйФайл,,);
	ОбщегоНазначения.ПодписатьФайл(ПрисоединенныйФайл, ИдентификаторФормы);
	ОбщегоНазначения.ПодписатьФайл(ПрисоединенныйФайл, ИдентификаторФормы, ДополнительныеПараметры = Неопределено);
	
	ПодписатьФайл(ПрисоединенныйФайл, ИдентификаторФормы, ДополнительныеПараметры = Неопределено);
	
	// фывафыва();
	
	а = Структура("");
	
КонецПроцедуры

Функция Структура(фыва)
	
КонецФункции