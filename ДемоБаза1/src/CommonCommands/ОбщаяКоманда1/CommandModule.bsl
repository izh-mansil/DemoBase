
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды, Знач	ЭтотОбъект = "фывафыва") Экспорт 
	// Вставить содержимое обработчика.
	//ПараметрыФормы = Новый Структура("", );
	//ОткрытьФорму("ОбщаяФорма.", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
	Автоформатировать();
	
	ЭтотОбъект.Автоформатировать();
	
КонецПроцедуры

&НаСервере
Процедура Автоформатировать()
	
	ОбщийМодуль3КлиентСервер.АвтоформатироватьКод();
	
КонецПроцедуры