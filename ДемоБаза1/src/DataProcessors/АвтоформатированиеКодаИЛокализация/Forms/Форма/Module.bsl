///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии ...
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ЗапуститьИЗавершить") Тогда
		ЗапуститьИЗавершить = Ложь;
	Иначе
		ЗапуститьИЗавершить = Параметры.ЗапуститьИЗавершить;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Статус = ПроверитьПлатформу836();
	Если НЕ ПустаяСтрока(Статус) Тогда
		Предупреждение(Статус);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДеревоСтандартовПоУмолчанию();
	
	#Если ТолстыйКлиентУправляемоеПриложение ИЛИ ТолстыйКлиентОбычноеПриложение Тогда
	Элементы.ТекстТонкийКлиент.Видимость = Ложь;
	#Иначе
	Элементы.ТекстТонкийКлиент.Видимость = Истина;
	#КонецЕсли
	
	Объект.ТипИсточника = 0;
	Объект.ВыгружатьКонфигурациюВФайлыXML = Истина;
	Объект.ЗагружатьКонфигурациюИзФайловXML = Истина;
	Объект.ОбновитьКонфигурациюБД = Ложь;
	
	УстановитьТекущуюСтраницу();
	
	Если ЗапуститьИЗавершить Тогда
		АвтоформатироватьКод();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПутьКБазеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru='Укажите каталог с информационной базой'");
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		Объект.ПутьКФайловойБазе = ДиалогОткрытияФайла.Каталог;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипИсточникаПриИзменении(Элемент)
	
	Если Объект.ТипИсточника = 0 Тогда
		Элементы.ГруппаИсточникБаза.Видимость = Истина;
		Элементы.ГруппаИсточникВыгрузкаXML.Видимость = Ложь;
		Элементы.ГруппаТипБазы.ТекущаяСтраница = Элементы.ГруппаФайловаяБаза;
	ИначеЕсли Объект.ТипИсточника = 1 Тогда
		Элементы.ГруппаИсточникБаза.Видимость = Истина;
		Элементы.ГруппаИсточникВыгрузкаXML.Видимость = Ложь;
		Элементы.ГруппаТипБазы.ТекущаяСтраница = Элементы.ГруппаКлиентСервернаяБаза;
	ИначеЕсли Объект.ТипИсточника = 2 Тогда
		Элементы.ГруппаИсточникБаза.Видимость = Ложь;
		Элементы.ГруппаИсточникВыгрузкаXML.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекущуюСтраницу()
	
	Объект.ПутьКБазе = СтрокаСоединенияИнформационнойБазы();
	Объект.ПутьКБазе = СокрЛП(Объект.ПутьКБазе);
	
	// Если на вход подается строка соединения с файловой базой, то получаем каталог из строки соединения.
	Если СтрНайти(Объект.ПутьКБазе, "File=") > 0 Тогда
		
		Объект.ПутьКФайловойБазе = НСтр(Объект.ПутьКБазе, "File");
		Объект.ТипИсточника = 0;
		Элементы.ГруппаТипБазы.ТекущаяСтраница = Элементы.ГруппаФайловаяБаза;
		
	// Если на вход подается строка соединения с серверной базой, то формируем путь к базе из строки соединения.
	ИначеЕсли СтрНайти(Объект.ПутьКБазе, "Srvr=") > 0 Тогда
		
		КластерБазы = НСтр(Объект.ПутьКБазе, "Srvr");
		ИмяБазы = НСтр(Объект.ПутьКБазе, "Ref");
		Объект.ТипИсточника = 1;
		Элементы.ГруппаТипБазы.ТекущаяСтраница = Элементы.ГруппаКлиентСервернаяБаза;
		
	КонецЕсли;
	
	Объект.Пользователь = ИмяПользователя();
	Объект.СтрокаЗапускаПлатформы = КаталогПрограммы() + "1cv8.exe";
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогХранилищаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru='Укажите каталог с хранилищем конфигурации'");
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		Объект.КаталогХранилища = ДиалогОткрытияФайла.Каталог;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаЗапускаПлатформыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru='Укажите исполняемый файл запуска платформы 1С:Предприятие'");
	ДиалогОткрытияФайла.Фильтр = "Исполняемый файл(1cv8.exe)|*.exe";
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		Объект.СтрокаЗапускаПлатформы = ДиалогОткрытияФайла.ПолноеИмяФайла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru='Укажите каталог с файлами выгрузки XML'");
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		Объект.КаталогВыгрузкиРезультат = КаталогДобавитьСлэш(ДиалогОткрытияФайла.Каталог);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагружатьКонфигурациюИзФайловXMLПриИзменении(Элемент)
	
	Элементы.ОбновитьКонфигурациюБД.Доступность = Объект.ЗагружатьКонфигурациюИзФайловXML;
	Если НЕ Объект.ЗагружатьКонфигурациюИзФайловXML Тогда
		Объект.ОбновитьКонфигурациюБД = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтандартыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если СтрСравнить(Поле.Имя, "СтандартыНаименование") <> 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийСтандарт = Стандарты.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если ТекущийСтандарт = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Гиперссылка = ТекущийСтандарт.Гиперссылка;
	
	Если НЕ ПустаяСтрока(Гиперссылка) Тогда
		ЗапуститьПриложение(Гиперссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтандартыФлагПриИзменении(Элемент)
	
	ТекущийСтандарт = Элементы.Стандарты.ТекущиеДанные;
	РодительскийСтандарт = ТекущийСтандарт.ПолучитьРодителя();
	
	Флаг = ТекущийСтандарт.Флаг;
	
	// Если это родительская ветка (стандарт), то меняем флаг у всех подчиненных веток (ошибок).
	Если РодительскийСтандарт = Неопределено Тогда
		Для Каждого ПодчиненныйСтандарт Из ТекущийСтандарт.ПолучитьЭлементы() Цикл
			ПодчиненныйСтандарт.Флаг = Флаг;
		КонецЦикла;
	Иначе
		
		// Если это подчиненная ветка (ошибка), то проверяем состояние флага родителя.
		Если РодительскийСтандарт.Флаг = Флаг Тогда
			Возврат;
		КонецЕсли;
		
		// Если флаг поставили, то устанавливаем его у родителя.
		Если Флаг Тогда
			РодительскийСтандарт.Флаг = Истина;
		Иначе
			// Если флаг сняли, то проверяем флаг других подчиненных веток.
			ФлагСнятУВсехПодчиненных = Истина;
			Для Каждого ПодчиненныйСтандарт Из РодительскийСтандарт.ПолучитьЭлементы() Цикл
				Если ПодчиненныйСтандарт.Флаг Тогда
					ФлагСнятУВсехПодчиненных = Ложь;
				КонецЕсли;
			КонецЦикла;
			
			// Если флаг у всех подчиненных снят, то снимаем его у родителя.
			Если ФлагСнятУВсехПодчиненных Тогда
				РодительскийСтандарт.Флаг = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьАвтоформатированиеКода(Команда)
	
	АвтоформатироватьКод();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьАнализКода(Команда)
	
	Статус = АвтоформатироватьКод(Ложь);
	
	Если Статус Тогда
		Параметр = Новый Структура("Объект", Объект);
		ФормаРезультат = ОткрытьФорму("ВнешняяОбработка.АвтоформатированиеКодаИЛокализация.Форма.Результат", Параметр);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииРаботыСФайламиИКаталогами

&НаКлиенте
Функция ФайлСуществуетНаКлиенте(ИмяФайла)
	
	Файл = Новый Файл(ИмяФайла);
	Возврат Файл.Существует();
	
КонецФункции

&НаСервере
Функция ФайлСуществуетНаСервере(ИмяФайла)
	
	Файл = Новый Файл(ИмяФайла);
	Возврат Файл.Существует();
	
КонецФункции

&НаСервере
Процедура ОчиститьКаталогиВыгрузки(Маска = "*")
	
	Попытка
		УдалитьФайлы(Объект.КаталогВыгрузки, Маска);
		УдалитьФайлы(Объект.КаталогВыгрузкиРезультат, Маска);
	Исключение
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура СкопироватьКаталогВыгрузки(Источник, Приемник)
	
	ДоступОбъект = РеквизитФормыВЗначение("Объект");
	ДоступОбъект.СкопироватьКаталогВыгрузки(Источник, Приемник);
	ЗначениеВРеквизитФормы(ДоступОбъект, "Объект");
	
КонецПроцедуры

Функция КаталогДобавитьСлэш(Каталог)
	
	Если НЕ СтрЗаканчиваетсяНа(Каталог, "\") Тогда
		Каталог = Каталог + "\";
	КонецЕсли;
	
	Возврат Каталог;
	
КонецФункции

#КонецОбласти

#Область КомандыЗапускаКонфигуратораВПакетномРежиме

&НаСервере
Функция ЗагрузитьКонфигурациюИзХранилища()
	
	КаталогХранилища = Объект.КаталогХранилища;
	
	Если ПустаяСтрока(КаталогХранилища) Тогда 
		Возврат "";
	КонецЕсли;
	
	ДоступОбъект = РеквизитФормыВЗначение("Объект");
	
	Статус = ДоступОбъект.ЗагрузитьКонфигурациюИзХранилища();
	Если НЕ ПустаяСтрока(Статус) Тогда 
		СтрокаСообщения = НСтр("ru='Не удалось загрузить конфигурацию из хранилища по причине:%1%2'");
		СтрокаСообщения = СтрШаблон(СтрокаСообщения, Символы.ПС, Статус);
		Возврат СтрокаСообщения;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ДоступОбъект, "Объект");
	
	Возврат "";
	
КонецФункции

&НаСервере
Функция ПодключитьКонфигурациюКХранилищу()
	
	КаталогХранилища = Объект.КаталогХранилища;
	
	Если ПустаяСтрока(КаталогХранилища) Тогда 
		Возврат "";
	КонецЕсли;
	
	ДоступОбъект = РеквизитФормыВЗначение("Объект");
	
	Статус = ДоступОбъект.ПодключитьКонфигурациюКХранилищу();
	Если НЕ ПустаяСтрока(Статус) Тогда 
		СтрокаСообщения = НСтр("ru='Не удалось подключить конфигурацию к хранилищу по причине:%1%2'");
		СтрокаСообщения = СтрШаблон(СтрокаСообщения, Символы.ПС, Статус);
		Возврат СтрокаСообщения;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ДоступОбъект, "Объект");
	
	Возврат "";
	
КонецФункции

&НаСервере
Функция ЗахватитьОбъектыКонфигурацииВХранилище()
	
	КаталогХранилища = Объект.КаталогХранилища;
	
	Если ПустаяСтрока(КаталогХранилища) Тогда 
		Возврат "";
	КонецЕсли;
	
	ДоступОбъект = РеквизитФормыВЗначение("Объект");
	
	Статус = ДоступОбъект.ЗахватитьОбъектыКонфигурацииВХранилище();
	Если НЕ ПустаяСтрока(Статус) Тогда 
		СтрокаСообщения = НСтр("ru='Не удалось захватить объекты конфигурации в хранилище по причине:%1%2'");
		СтрокаСообщения = СтрШаблон(СтрокаСообщения, Символы.ПС, Статус);
		Возврат СтрокаСообщения;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ДоступОбъект, "Объект");
	
	Возврат "";
	
КонецФункции

&НаСервере
Функция ВыгрузитьКонфигурациюВФайлыXML()
	
	Объект.КаталогВыгрузки = ПолучитьИмяВременногоФайла("");
	КаталогДобавитьСлэш(Объект.КаталогВыгрузки);
	СоздатьКаталог(Объект.КаталогВыгрузки);
	
	// Если указан готовый каталог выгрузки XML, то выгружать конфигурацию в XML не надо.
	// Копируем файлы выгрузки из указанного каталога и выходим.
	Если НЕ Объект.ВыгружатьКонфигурациюВФайлыXML Тогда
		СкопироватьКаталогВыгрузки(Объект.КаталогВыгрузкиРезультат, Объект.КаталогВыгрузки);
		Возврат "";
	КонецЕсли;
	
	Объект.КаталогВыгрузкиРезультат = ПолучитьИмяВременногоФайла("");
	КаталогДобавитьСлэш(Объект.КаталогВыгрузкиРезультат);
	СоздатьКаталог(Объект.КаталогВыгрузкиРезультат);
	
	ОчиститьКаталогиВыгрузки();
	
	ДоступОбъект = РеквизитФормыВЗначение("Объект");
	
	Статус = ДоступОбъект.ВыгрузитьКонфигурациюВФайлыXML();
	Если НЕ ПустаяСтрока(Статус) Тогда 
		СтрокаСообщения = НСтр("ru='Не удалось выгрузить конфигурацию в файлы XML по причине:%1%2'");
		СтрокаСообщения = СтрШаблон(СтрокаСообщения, Символы.ПС, Статус);
		Возврат СтрокаСообщения;
	КонецЕсли;
	ЗначениеВРеквизитФормы(ДоступОбъект, "Объект");
	
	СкопироватьКаталогВыгрузки(Объект.КаталогВыгрузки, Объект.КаталогВыгрузкиРезультат);
	
	Возврат "";
	
КонецФункции

&НаСервере
Функция ЗагрузитьКонфигурациюИзФайловXML()
	
	ДоступОбъект = РеквизитФормыВЗначение("Объект");
	Статус = ДоступОбъект.ЗагрузитьКонфигурациюИзФайловXML();
	ЗначениеВРеквизитФормы(ДоступОбъект, "Объект");
	
	Возврат Статус;
	
КонецФункции

&НаСервере
Функция ОбновитьКонфигурациюБД()
	
	ДоступОбъект = РеквизитФормыВЗначение("Объект");
	Статус = ДоступОбъект.ОбновитьКонфигурациюБД();
	ЗначениеВРеквизитФормы(ДоступОбъект, "Объект");
	
	Возврат Статус;
	
КонецФункции

&НаКлиенте
Процедура ЗагрузитьКонфигурациюИзФайловXMLИОбновить(ЗагрузкаФайловXMLПрошлаУспешно)
	
	ЗагрузкаФайловXMLПрошлаУспешно = Истина;
	
	Если НЕ Объект.ЗагружатьКонфигурациюИзФайловXML Тогда
		Возврат;
	КонецЕсли;
	
	Статус = ЗагрузитьКонфигурациюИзФайловXML();
	Если ПустаяСтрока(Статус) Тогда 
		апк_Сообщить(НСтр("ru='Измененные файлы XML успешно загружены в конфигурацию.'"));
	Иначе 
		СтрокаСообщения = НСтр("ru='Загрузка файлов XML завершилась с ошибками:'") + Символы.ПС + Статус;
		апк_Сообщить(СтрокаСообщения);
		ЗагрузкаФайловXMLПрошлаУспешно = Ложь;
		Возврат;
	КонецЕсли;
	
	Если Объект.ОбновитьКонфигурациюБД Тогда
		
		Статус = ОбновитьКонфигурациюБД();
		Если ПустаяСтрока(Статус) Тогда 
			апк_Сообщить(НСтр("ru='Обновление конфигурации успешно завершено.'"));
		Иначе
			СтрокаСообщения = НСтр("ru='Обновление конфигурации базы данных завершилось с ошибками: '") + Символы.ПС + Статус;
			апк_Сообщить(СтрокаСообщения);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьИзмененныеОбъектыВХранилищеИОтменитьЗахват(ЗагрузкаФайловXMLПрошлаУспешно)
	
	// Если не надо помещать объекты в хранилище, то выходим.
	Если (НЕ Объект.ПомещатьИзмененныеОбъектыВХранилище) ИЛИ ПустаяСтрока(Объект.КаталогХранилища) Тогда
		Возврат;
	КонецЕсли;
	
	// Помещаем объекты в хранилище, если файлы XML успешно загружены в конфигурацию БД.
	Если ЗагрузкаФайловXMLПрошлаУспешно Тогда
		СообщитьПользователюОбИзмененныхОбъектахНезахваченныхВХранилище();
		
		Состояние(НСтр("ru='Выполняется загрузка измененных объектов в хранилище'"));
		Статус = ПоместитьИзмененныеОбъектыВХранилище();
		Если ПустаяСтрока(Статус) Тогда 
			апк_Сообщить(НСтр("ru='Все захваченные измененные объекты успешно помещены в хранилище.'"));
		Иначе 
			СтрокаСообщения = НСтр("ru='Помещение захваченных объектов в хранилище завершилось с ошибками:'") + Символы.ПС + Статус;
			апк_Сообщить(СтрокаСообщения);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Состояние(НСтр("ru='Выполняется отмена захвата объектов в хранилище'"));
	Статус = ОтменитьЗахватОбъектовВХранилище();
	Если ПустаяСтрока(Статус) Тогда 
		апк_Сообщить(НСтр("ru='Захват неизмененных объектов в хранилище успешно отменен.'"));
	Иначе 
		СтрокаСообщения = НСтр("ru='Отмена захвата неизмененных объектов завершилась с ошибками:'") + Символы.ПС + Статус;
		апк_Сообщить(СтрокаСообщения);
	КонецЕсли;
	
	Состояние();
	
КонецПроцедуры

&НаСервере
Функция ПоместитьИзмененныеОбъектыВХранилище()
	
	ДоступОбъект = РеквизитФормыВЗначение("Объект");
	Статус = ДоступОбъект.ПоместитьИзмененныеОбъектыВХранилище();
	ЗначениеВРеквизитФормы(ДоступОбъект, "Объект");
	
	Возврат Статус;
	
КонецФункции

&НаСервере
Функция ОтменитьЗахватОбъектовВХранилище()
	
	ДоступОбъект = РеквизитФормыВЗначение("Объект");
	Статус = ДоступОбъект.ОтменитьЗахватОбъектовВХранилище();
	ЗначениеВРеквизитФормы(ДоступОбъект, "Объект");
	
	Возврат Статус;
	
КонецФункции

#КонецОбласти

#Область ПроцедурыПриведенияКСтандартам

&НаСервере
Процедура ПривестиКонфигурациюКСтандартамНаСервере(ЗначениеФлагов)
	
	ДоступОбъект = РеквизитФормыВЗначение("Объект");
	ДоступОбъект.ПривестиКонфигурациюКСтандартам(ЗначениеФлагов);
	ЗначениеВРеквизитФормы(ДоступОбъект, "Объект");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыФункций

&НаСервере
Процедура ЗаполнитьРезультатНаСервере()
	
	ДоступОбъект = РеквизитФормыВЗначение("Объект");
	ДоступОбъект.ЗаполнитьРезультат();
	ЗначениеВРеквизитФормы(ДоступОбъект, "Объект");
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТаблицуСтандартовИзМакетаНаСервере()
	
	ДоступОбъект = РеквизитФормыВЗначение("Объект");
	ТаблицаСтандартов = ДоступОбъект.ПолучитьТаблицуСтандартовИзМакета();
	ЗначениеВРеквизитФормы(ДоступОбъект, "Объект");
	
	Возврат ТаблицаСтандартов;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьДеревоСтандартовПоУмолчанию()
	
	ДеревоСтандартов = РеквизитФормыВЗначение("Стандарты");
	
	ТаблицаСтандартов = ПолучитьТаблицуСтандартовИзМакетаНаСервере();
	
	Для Каждого СтрокаТаблицы Из ТаблицаСтандартов Цикл
		
		КлючРодителя = СтрокаТаблицы.КлючРодителя;
		
		// Если ключ родителя не заполнен, то добавляем в корень дерева.
		Если ПустаяСтрока(КлючРодителя) Тогда
			ВеткаРодителя = ДеревоСтандартов;
		Иначе
			// Иначе ищем ветку родителя среди существующих по ключу.
			ВеткаРодителя = ДеревоСтандартов.Строки.Найти(КлючРодителя, "Ключ", Истина);
			Если ВеткаРодителя = Неопределено Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		ВеткаСтандарта = ВеткаРодителя.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(ВеткаСтандарта, СтрокаТаблицы);
		
		ВеткаСтандарта.Флаг = НЕ ПустаяСтрока(СтрокаТаблицы.ВыбранПоУмолчанию);
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоСтандартов, "Стандарты");
	
КонецПроцедуры

&НаКлиенте
Функция АвтоформатироватьКод(ЗагрузитьКонфигурациюИзXML = Истина)
	
	Статус = ПроверитьЗаполнениеНастроек();
	Если НЕ ПустаяСтрока(Статус) Тогда
		апк_Сообщить(Статус, СтатусСообщения.Внимание);
		Возврат Ложь;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	// Установим флаг выгрузки и загрузки в зависимости от типа источника.
	Объект.ВыгружатьКонфигурациюВФайлыXML = (Объект.ТипИсточника <> 2);
	Если НЕ Объект.ВыгружатьКонфигурациюВФайлыXML Тогда
		Объект.ЗагружатьКонфигурациюИзФайловXML = Ложь;
	КонецЕсли;
	
	ХранилищеУказано = НЕ ПустаяСтрока(Объект.КаталогХранилища);
	
	Если Объект.ВыгружатьКонфигурациюВФайлыXML И ХранилищеУказано Тогда
		// Если флаг "Помещать обработанные объекты в хранилище" установлен, то подключаемся к хранилищу
		// и пытаемся захватить в нем все объекты.
		Если Объект.ПомещатьИзмененныеОбъектыВХранилище Тогда
			Состояние(НСтр("ru='Выполняется подключение конфигурации к хранилищу'"));
			Статус = ПодключитьКонфигурациюКХранилищу();
			
			Если ПустаяСтрока(Статус) Тогда
				апк_Сообщить(НСтр("ru='Конфигурация успешно подключена к хранилищу.'"));
			Иначе
				апк_Сообщить(Статус);
				Возврат Ложь;
			КонецЕсли;
			
			Состояние(НСтр("ru='Выполняется захват объектов конфигурации в хранилище'"));
			Статус = ЗахватитьОбъектыКонфигурацииВХранилище();
			
			Если ПустаяСтрока(Статус) Тогда
				апк_Сообщить(НСтр("ru='Объекты конфигурации успешно захвачены в хранилище.'"));
			Иначе
				апк_Сообщить(Статус);
				Возврат Ложь;
			КонецЕсли;
		Иначе
			// Если флаг не установлен, то только загружаем конфигурацию из хранилища.
			Состояние(НСтр("ru='Выполняется загрузка конфигурации из хранилища'"));
			Статус = ЗагрузитьКонфигурациюИзХранилища();
			
			Если ПустаяСтрока(Статус) Тогда
				апк_Сообщить(НСтр("ru='Конфигурация успешно загружена из хранилища.'"));
			Иначе
				апк_Сообщить(Статус);
				Возврат Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.ВыгружатьКонфигурациюВФайлыXML Тогда
		Состояние(НСтр("ru='Выполняется выгрузка конфигурации в файлы XML'"));
	КонецЕсли;
	
	Статус = ВыгрузитьКонфигурациюВФайлыXML();
	
	Если Объект.ВыгружатьКонфигурациюВФайлыXML Тогда
		Если ПустаяСтрока(Статус) Тогда
			апк_Сообщить(НСтр("ru='Выгрузка конфигурации в файлы XML завершена.'"));
			Состояние();
		Иначе
			апк_Сообщить(Статус);
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьПравилаПоддержкиНаСервере();
	ЗаполнитьРезультатНаСервере();
	
	апк_Сообщить(НСтр("ru='Начало приведения конфигурации к стандартам.'"));
	
	ЗначениеФлагов = ПолучитьЗначениеФлагов();
	ПривестиКонфигурациюКСтандартамНаСервере(ЗначениеФлагов);
	
	апк_Сообщить(НСтр("ru='Приведение конфигурации к стандартам завершено.'"));
	
	ЗаполнитьПравилаПоддержкиДляИзмененныхОбъектовНаСервере();
	
	Если ЗагрузитьКонфигурациюИзXML И Объект.ЗагружатьКонфигурациюИзФайловXML Тогда
		
		ЗагрузкаФайловXMLПрошлаУспешно = Неопределено;
		
		Состояние(НСтр("ru='Выполняется загрузка конфигурации из файлов XML'"));
		ЗагрузитьКонфигурациюИзФайловXMLИОбновить(ЗагрузкаФайловXMLПрошлаУспешно);
		Состояние();
		
		ПоместитьИзмененныеОбъектыВХранилищеИОтменитьЗахват(ЗагрузкаФайловXMLПрошлаУспешно);
		
		Объект.Результат.Очистить();
		
		ОчиститьКаталогиВыгрузки("");
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Функция ПроверитьЗаполнениеНастроек()
	
	ПутьКБазе = КаталогДобавитьСлэш(Объект.ПутьКФайловойБазе) + "1CV8.1CD";
	
	Если Объект.ТипИсточника = 0 Тогда
		
		Если ПустаяСтрока(Объект.ПутьКФайловойБазе) Тогда
			Возврат НСтр("ru='Поле ""Каталог информационной базы"" не заполнено'");
		ИначеЕсли НЕ ФайлСуществуетНаКлиенте(ПутьКБазе) Тогда
			Возврат НСтр("ru='Информационной базы по указанному пути не существует'");
		Иначе
			Объект.ПутьКБазе = Объект.ПутьКФайловойБазе;
		КонецЕсли;
		
	ИначеЕсли Объект.ТипИсточника = 1 Тогда
		
		Если ПустаяСтрока(КластерБазы) И ПустаяСтрока(ИмяБазы) Тогда
			Возврат НСтр("ru='Не заполнены поля ""Кластер серверов 1С:Предприятия"" и ""Имя информационной базы в кластере""'");
		ИначеЕсли ПустаяСтрока(КластерБазы) Тогда 
			Возврат НСтр("ru='Не заполнено поле ""Кластер серверов 1С:Предприятия""'");
		ИначеЕсли ПустаяСтрока(ИмяБазы) Тогда 
			Возврат НСтр("ru='Не заполнено поле ""Имя информационной базы в кластере""'");
		Иначе
			Объект.ПутьКБазе = "Srvr=""" + КластерБазы + """;Ref=""" + ИмяБазы + """";
		КонецЕсли;
		
	ИначеЕсли Объект.ТипИсточника = 2 Тогда
		
		Если ПустаяСтрока(Объект.КаталогВыгрузкиРезультат) Тогда
			Возврат НСтр("ru='Не заполнено поле ""Каталог выгрузки файлов XML""'");
		ИначеЕсли НЕ ФайлСуществуетНаКлиенте(Объект.КаталогВыгрузкиРезультат) Тогда
			Возврат НСтр("ru='Каталог выгрузки файлов XML по указанному пути не существует'");
		КонецЕсли;
		
		КаталогДобавитьСлэш(Объект.КаталогВыгрузкиРезультат);
		
	КонецЕсли;
	
	// Проверим наличие платформы на сервере.
	Если НЕ ФайлСуществуетНаСервере(Объект.СтрокаЗапускаПлатформы) Тогда 
		Возврат НСтр("ru='На сервере не найден файл запуска платформы по пути:'") + Символы.ПС + Объект.СтрокаЗапускаПлатформы;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

&НаКлиенте
Функция ПолучитьЗначениеФлагов()
	
	ЗначениеФлагов = Новый Структура;
	
	Для Каждого ТекущийСтандарт Из Стандарты.ПолучитьЭлементы() Цикл
		
		ЗначениеФлагов.Вставить(ТекущийСтандарт.Ключ, ТекущийСтандарт.Флаг);
		
		Для Каждого ПодчиненныйСтандарт Из ТекущийСтандарт.ПолучитьЭлементы() Цикл
			ЗначениеФлагов.Вставить(ПодчиненныйСтандарт.Ключ, ПодчиненныйСтандарт.Флаг);
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ЗначениеФлагов;
	
КонецФункции

&НаКлиенте
Процедура апк_Сообщить(Знач ТекстСообщения, Статус = Неопределено)
	
	Если Статус = Неопределено Тогда
		Статус = СтатусСообщения.Обычное;
	КонецЕсли;
	
	ТекстСообщения = "[" + ТекущаяДата() + "]: " + ТекстСообщения;
	Сообщить(ТекстСообщения, Статус);
	
КонецПроцедуры

&НаСервере
Функция ПроверитьПлатформу836()
	
	ДоступОбъект = РеквизитФормыВЗначение("Объект");
	Статус = ДоступОбъект.ПроверитьПлатформу836();
	ЗначениеВРеквизитФормы(ДоступОбъект, "Объект");
	
	Возврат Статус;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПравилаПоддержкиНаСервере()
	
	ДоступОбъект = РеквизитФормыВЗначение("Объект");
	ДоступОбъект.ЗаполнитьПравилаПоддержки();
	ЗначениеВРеквизитФормы(ДоступОбъект, "Объект");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПравилаПоддержкиДляИзмененныхОбъектовНаСервере()
	
	ДоступОбъект = РеквизитФормыВЗначение("Объект");
	ДоступОбъект.ЗаполнитьПравилаПоддержкиДляИзмененныхОбъектов();
	ЗначениеВРеквизитФормы(ДоступОбъект, "Объект");
	
КонецПроцедуры

&НаСервере
Функция ПолучитьИзмененныеОбъектыНезахваченныеВХранилище()
	
	// Получаем измененные объекты, которые не удалось захватить в хранилище.
	ДоступОбъект = РеквизитФормыВЗначение("Объект");
	ТаблицаИзмененныхОбъектов = ДоступОбъект.ПолучитьТаблицуИзмененныхОбъектовНаСервере(Ложь);
	ЗначениеВРеквизитФормы(ДоступОбъект, "Объект");
	
	Если ТаблицаИзмененныхОбъектов.Количество() = 0 Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	ТаблицаИзмененныхОбъектов.Свернуть("Объект");
	
	Возврат ТаблицаИзмененныхОбъектов.ВыгрузитьКолонку("Объект");
	
КонецФункции

&НаКлиенте
Процедура СообщитьПользователюОбИзмененныхОбъектахНезахваченныхВХранилище()
	
	// Если не надо помещать объекты в хранилище, то выходим.
	Если (НЕ Объект.ПомещатьИзмененныеОбъектыВХранилище) ИЛИ ПустаяСтрока(Объект.КаталогХранилища) Тогда
		Возврат;
	КонецЕсли;
	
	МассивИзмененныхОбъектов = ПолучитьИзмененныеОбъектыНезахваченныеВХранилище();
	Если МассивИзмененныхОбъектов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru='Обнаружены измененные объекты, которые не удалось захватить в хранилище под указанным пользователем.
		|Изменения для этих объектов не будут загружены в хранилище.'");
	Для Каждого ИзмененныйОбъект Из МассивИзмененныхОбъектов Цикл
		ТекстСообщения = ТекстСообщения + Символы.ПС + ИзмененныйОбъект;
	КонецЦикла;
	
	апк_Сообщить(ТекстСообщения);
	
КонецПроцедуры

#КонецОбласти