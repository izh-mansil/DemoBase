///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии ...
///////////////////////////////////////////////////////////////////////////////////////////////////////

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	б = Параметры;
	а = 1;
	ОбновитьДоступностьЭлементовФормы(ЭтаФорма);
	
	ОбщийМодуль6.Тест1();
	
КонецПроцедуры

&НаСервере
Функция ВызватьАварийноеЗавершениеСервер()
	
	СтруктураНаСервере = Новый Структура();
	СтруктураНаСервере.Вставить("Свойство1", Неопределено);
	СтруктураНаСервере.Вставить("Свойство2", СтруктураНаСервере); // Циклическая ссылка структуры саму на себя
	
	Возврат СтруктураНаСервере;
	
КонецФункции // В момент возврата с сервера на клиент, рабочий процесс упадет с дампом

&НаКлиенте
Процедура ВызватьАварийноеЗавершение(Команда)
	
	СтруктураНаКлиенте = ВызватьАварийноеЗавершениеСервер();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьДоступностьЭлементовФормы(ЭтаФорма) 
	
	Объект1 = ЭтаФорма.Объект;
	
КонецПроцедуры
// АПК:567-выкл пропустить

&НаКлиенте
Процедура КаталогВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Объект.ПутьКФайлу); // АПК:567-вкл дальше проверяем
	ЗапуститьПриложение(Объект.ПутьКФайлу);
	ОписаниеОповещения = Новый ОписаниеОповещения("КаталогВыгрузкиНачалоВыбораПродолжение", ЭтотОбъект);
	НачатьПодключениеРасширенияРаботыСФайлами(ОписаниеОповещения);
КонецПроцедуры

// АПК:567-вкл, АПК:565-вкл дальше проверяем

// АПК:566-выкл пропустить

&НаКлиенте
Процедура ПутьКФайлуОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Объект.ПутьКФайлу); // АПК:566 пропустить
КонецПроцедуры

&НаКлиенте
Функция СтруктураНаКлиенте()
	
	СтруктураНаКлиентеПриОткрытии2 = Новый Структура;
	СтруктураНаКлиентеПриОткрытии2.Вставить("Ключ1", СтруктураНаКлиентеПриОткрытии2);
	
	Возврат СтруктураНаКлиентеПриОткрытии2;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СтруктураНаКлиентеПриОткрытии = Новый Структура;
	СтруктураНаКлиентеПриОткрытии.Вставить("Ключ1", СтруктураНаКлиентеПриОткрытии);
	
	СтруктураНаКлиентеПриОткрытии3 = СтруктураНаКлиенте();
	
	ВызватьАварийноеЗавершениеСервер();
	
	//ВызватьАварийноеЗавершение(Неопределено);
	
КонецПроцедуры

// забыли включить обратно

