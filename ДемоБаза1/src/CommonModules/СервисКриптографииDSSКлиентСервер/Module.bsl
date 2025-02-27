///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Базовая функция для формирования результата выполнения функций и процедур в серверных вызовах.
// Данный формат возврата результата используется в большинстве функций и процедур подсистемы.
// Содержит как обязательные поля, так и дополнительные поля.
// Состав дополнительных полей зависит от состояния операции и вида операции.
// Если "МаркерОбновлен" = Истина, то добавляется поле "НастройкиПользователя".
//
// Параметры: 
//  Выполнено - Булево - устанавливает признак успешности выполнения
//
// Возвращаемое значение:
//  Структура:
//    * Выполнено 		- Булево - признак успешного выполнения вызова.
//						Если Истина, то обычно структура дополняется полем "Результат".
//    * МаркерОбновлен	- Булево - признак, что в процессе работы обновился токен авторизации.
//						Если Истина, структура дополняется полем "НастройкиПользователя".
//    * Ошибка			- Строка - содержит форматированный текст ошибки, если поле Выполнено = Ложь
//    * КодОшибки		- Строка - содержит код ошибки
//    * СтатусОшибки	- см. СервисКриптографииDSSКлиентСервер.СтатусОшибки
//
Функция ОтветСервисаПоУмолчанию(Выполнено = Истина) Экспорт
	
	ОтветМетода 	= Новый Структура;
	ОтветМетода.Вставить("Выполнено", Выполнено);
	ОтветМетода.Вставить("Ошибка", "");
	ОтветМетода.Вставить("КодОшибки", "");
	ОтветМетода.Вставить("МаркерОбновлен", Ложь);
	ОтветМетода.Вставить("СтатусОшибки", "");
	
	Возврат ОтветМетода;
	
КонецФункции

#КонецОбласти
