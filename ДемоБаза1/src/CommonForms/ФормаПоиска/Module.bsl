&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Перем Настройки;

	Настройки = ХранилищеСистемныхНастроек.Загрузить(ИмяФормы, "ПредыдущиеПоиски");
	Если Настройки <> Неопределено Тогда

		ПоследниеЗапросы = Настройки;

	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СформироватьСтрокуНавигации(ВсегоСтраниц, ПолноеКоличество)
	
	Перем РазмерПорции;
	Перем ТекущаяСтраница;
	РазмерПорции = 10;
	
	Если ВсегоСтраниц <= 1 Тогда
		
		Элементы.ГруппаНавигации.Видимость = Ложь; 
		Возврат;
		
	КонецЕсли;
	
	Если ТекущаяПозиция > 0 Тогда

		Элементы.КнопкаНачало.Доступность= Истина;
		Элементы.КнопкаПредыдущая.Доступность= Истина;
	Иначе
		Элементы.КнопкаНачало.Доступность= Ложь;
		Элементы.КнопкаПредыдущая.Доступность= Ложь;
	КонецЕсли;
	
	ТекущаяСтраница = ТекущаяПозиция / РазмерПорции + 1;
	Элементы.ДекорацияТекущаяСтраницаЗначение.Заголовок = ТекущаяСтраница;
	
	Если ТекущаяПозиция + РазмерПорции < ПолноеКоличество Тогда

		Элементы.КнопкаСледующая.Доступность= Истина;
	Иначе

		Элементы.КнопкаСледующая.Доступность= Ложь;
	КонецЕсли;
	
	Элементы.ГруппаНавигации.Видимость = Истина; 
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПоискНаСервере()

	Перем Элемент;
	Перем РазмерПорции;
	Перем СписокПоиска;
	Перем ПолноеКоличество;
	Перем ВсегоСтраниц;
	Перем ЭлементыФорматированойСтроки;
	Перем ТекущийИндекс;
	Перем XML;
	Перем СловоПоиска;
	Перем Позиция;
	
	Элемент = ПоследниеЗапросы.НайтиПоЗначению(СтрокаПоиска);
	Если Элемент = Неопределено Тогда

		ПоследниеЗапросы.Вставить(0, СтрокаПоиска);
		Пока ПоследниеЗапросы.Количество() > 10 Цикл

			ПоследниеЗапросы.Удалить(ПоследниеЗапросы[ПоследниеЗапросы.Количество() - 1]);

		КонецЦикла; 
		ХранилищеСистемныхНастроек.Сохранить(ИмяФормы, "ПредыдущиеПоиски", ПоследниеЗапросы);
	Иначе
		Позиция = ПоследниеЗапросы.Индекс(Элемент);
		Если Позиция > 0 Тогда
			ПоследниеЗапросы.Сдвинуть(Позиция, -Позиция);
			ХранилищеСистемныхНастроек.Сохранить(ИмяФормы, "ПредыдущиеПоиски", ПоследниеЗапросы);
		КонецЕсли;
	КонецЕсли;  
		
	ЗначенияРезультата.Очистить();
	
	РазмерПорции = 10;
	СписокПоиска = ПолнотекстовыйПоиск.СоздатьСписок(СтрокаПоиска, РазмерПорции);
	
	Если ТекущаяПозиция = 0 Тогда

		СписокПоиска.ПерваяЧасть();

	Иначе

		СписокПоиска.СледующаяЧасть(ТекущаяПозиция - РазмерПорции);

	КонецЕсли;
	
	ПолноеКоличество = СписокПоиска.ПолноеКоличество();
	ТекущаяПозиция = СписокПоиска.НачальнаяПозиция();
	Если ПолноеКоличество = 0 Тогда

		Элементы.СтраницыРезультатов.ТекущаяСтраница = Элементы.СтраницаПоиска;
		Элементы.ГруппаНавигации.Видимость = Ложь; 
		Возврат;

	КонецЕсли;

	ВсегоСтраниц = Цел((ПолноеКоличество - 1) / РазмерПорции) + 1;
	Если ПолноеКоличество > ВсегоСтраниц * РазмерПорции Тогда

		ВсегоСтраниц = ВсегоСтраниц + 1;

	КонецЕсли;

	ЭлементыФорматированойСтроки = Новый Массив();
	
	ТекущийИндекс = 0;
	
	XML = СписокПоиска.ПолучитьОтображение(ВидОтображенияПолнотекстовогоПоиска.XML);
	
	Пока XML.Прочитать() Цикл
		
		Если XML.ТипУзла = ТипУзлаXML.НачалоЭлемента И XML.ЛокальноеИмя = "item" Тогда 
			// Представление
			XML.Прочитать();
			XML.Пропустить();
			
			ЭлементСписка = СписокПоиска.Получить(ТекущийИндекс);
			ЗначенияРезультата.Добавить(ЭлементСписка.Значение);
			
			ЭлементыФорматированойСтроки.Добавить(Символы.ПС);
			
			ЭлементыФорматированойСтроки.Добавить(Новый ФорматированнаяСтрока("" 
													+ ЭлементСписка.Метаданные + ": "
													+ ЭлементСписка.Представление + Символы.ПС,,,,
													"#sel_num=" + ТекущийИндекс ));
		

			СловоПоиска = Ложь;
			// textPortion
			Пока XML.Прочитать() Цикл 
				Если XML.ТипУзла = ТипУзлаXML.КонецЭлемента И XML.ЛокальноеИмя = "textPortion" Тогда 
					Прервать;
				КонецЕсли;
				Если XML.ЛокальноеИмя = "foundWord" Тогда 
					Если XML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда 
						СловоПоиска = Истина;
					КонецЕсли;
					Если XML.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда 
						СловоПоиска = Ложь;
					КонецЕсли;
				КонецЕсли;
				
				Если XML.ТипУзла = ТипУзлаXML.Текст ИЛИ XML.ТипУзла = ТипУзлаXML.ПробельныеСимволы Тогда 
					Если СловоПоиска Тогда
						ЭлементыФорматированойСтроки.Добавить(Новый ФорматированнаяСтрока(XML.Значение,Новый Шрифт(,, Истина), WebЦвета.Зеленый));
					Иначе
						ЭлементыФорматированойСтроки.Добавить(XML.Значение);
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;

			ЭлементыФорматированойСтроки.Добавить(Символы.ПС);
			ТекущийИндекс = ТекущийИндекс + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	
	Элементы.РезультатыПоиска.Заголовок = Новый ФорматированнаяСтрока(ЭлементыФорматированойСтроки); 
	
	СформироватьСтрокуНавигации(ВсегоСтраниц, ПолноеКоличество);
	
	
	Элементы.СтраницыРезультатов.ТекущаяСтраница = Элементы.СтраницаРезультатаПоиска;
	
КонецПроцедуры

&НаКлиенте
Функция ЭтоНавигационнаяСсылка(Стр)

	Перем Ссылка;
	Перем СсылкаИБ;

	Ссылка = ВРег(Стр);
	Если Найти(Ссылка, "E1CIB/") = 1 Тогда

		Возврат Истина;

	КонецЕсли;
	
	Если Найти(Ссылка, "HTTP://") = 1 Или Найти(Ссылка, "HTTPS://") = 1 Или Найти(Ссылка, "E1C://") = 1 Тогда

		Возврат Истина;

	КонецЕсли;

	СсылкаИБ = ВРег(ПолучитьНавигационнуюСсылкуИнформационнойБазы());
	Если Найти(Ссылка, СсылкаИБ) = 1 Тогда

		Возврат Истина;

	КонецЕсли;

	Если Прав(СсылкаИБ, 1) = "/" Тогда

		СсылкаИБ = Лев(СсылкаИБ, СтрДлина(СсылкаИБ) - 1);
		Если Найти(Ссылка, СсылкаИБ) = 1 Тогда

			Возврат Истина;

		КонецЕсли;

	КонецЕсли;

	Возврат Ложь;

КонецФункции

&НаКлиенте
Процедура ВыполнитьПоискНаКлиенте()

	Если ЭтоНавигационнаяСсылка(СтрокаПоиска) Тогда

		ПерейтиПоНавигационнойСсылке(СтрокаПоиска);
		Возврат;

	КонецЕсли;

	ЗначенияРезультата.Очистить();
	ТекущаяПозиция = 0;
	Если СокрЛ(СтрокаПоиска) <> "" Тогда

		ВыполнитьПоискНаСервере();

	Иначе

		Элементы.СтраницыРезультатов.ТекущаяСтраница = Элементы.СтраницаПодсказки;
		Элементы.ГруппаНавигации.Видимость = Ложь; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПоиск(Команда)

	ВыполнитьПоискНаКлиенте();

КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)

	ПодключитьОбработчикОжидания("ВыполнитьПоискНаКлиенте", 0.1, Истина);

КонецПроцедуры

&НаКлиенте
Процедура РезультатыПоискаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)

	Перем Идентификатор;
	Перем Значение;
	Перем Позиция;
	Перем НомерВСписке;
	Перем ЗначениеДляОткрытия;
	Перем ПодСтрока;

	Если НавигационнаяСсылкаФорматированнойСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Позиция = Найти(НавигационнаяСсылкаФорматированнойСтроки, "#");

	Если Позиция = 0 Тогда 
		Возврат;
	КонецЕсли;

	ПодСтрока = Прав(НавигационнаяСсылкаФорматированнойСтроки, СтрДлина(НавигационнаяСсылкаФорматированнойСтроки) - Позиция);
	Позиция = Найти(ПодСтрока, "=");
	Если Позиция = 0 Тогда 
		Возврат;
	КонецЕсли;

	Идентификатор = Сред(ПодСтрока, 1, Позиция - 1);
	Значение = Прав(ПодСтрока, СтрДлина(ПодСтрока) - Позиция);

	Если Идентификатор = "sel_num" Тогда

		СтандартнаяОбработка = Ложь;
		НомерВСписке = Число(Значение);
		
		ЗначениеДляОткрытия = ЗначенияРезультата[НомерВСписке].Значение;
		ПоказатьЗначение(, ЗначениеДляОткрытия);
		Возврат;

	КонецЕсли;

	Если Идентификатор = "prev_text" Тогда

		СтандартнаяОбработка = Ложь;
		СтрокаПоиска = Значение;
		ВыполнитьПоискНаКлиенте();
		Возврат;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КнопкаНачалоНажатие(Элемент)
	ТекущаяПозиция = 0;
	ЗначенияРезультата.Очистить();
	ВыполнитьПоискНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура КнопкаПредыдущаяНажатие(Элемент)
	ТекущаяПозиция = ТекущаяПозиция + 10;
	ЗначенияРезультата.Очистить();
	ВыполнитьПоискНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура КнопкаСледующаяНажатие(Элемент)
	ТекущаяПозиция = ТекущаяПозиция - 10;
	ЗначенияРезультата.Очистить();
	ВыполнитьПоискНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если ПоследниеЗапросы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	ДанныеВыбора = Новый СписокЗначений();
	Для Каждого Элемент Из ПоследниеЗапросы Цикл
		ДанныеВыбора.Добавить(Элемент.Значение);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ИсторияПоиска(Команда)
	ПоказатьВыборИзМеню(Новый ОписаниеОповещения("ОкончаниеВыбораПоследнихЗапросов", ЭтаФорма), ПоследниеЗапросы, Элементы.ИсторияПоиска);
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеВыбораПоследнихЗапросов(ВыбранныйЗапрос, ДопПараметры = Неопределено) Экспорт
	Если ВыбранныйЗапрос = Неопределено Тогда
		Возврат;
	КонецЕсли;
	СтрокаПоиска = ВыбранныйЗапрос.Значение;
	ВыполнитьПоискНаКлиенте();
КонецПроцедуры
