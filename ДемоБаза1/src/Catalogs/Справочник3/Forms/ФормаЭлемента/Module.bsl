///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии ...
///////////////////////////////////////////////////////////////////////////////////////////////////////

&НаКлиенте
Процедура ОбработкаОповещения2(ИмяСобытия, Параметр, Источник)
	// Вставить содержимое обработчика
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПередЗаписьюНаСервере()
	// Вставить содержимое обработчика
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ПередЗаписьюНаСервере();
КонецПроцедуры

