///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии ...
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Справочники.ИдентификаторыОбъектовМетаданных.ПередЗаписьюОбъекта(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Справочники.ИдентификаторыОбъектовМетаданных.ПередУдалениемОбъекта(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли