
&НаСервере
Процедура ПолучитьЦиклическуюСсылкуНаСервере()
	
	ОбщийМодуль6.Тест1();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьЦиклическуюСсылку(Команда)
	ПолучитьЦиклическуюСсылкуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьЦиклическуюСсылкуНаКлиенте(Команда)
	
	СтруктураНаКлиенте = Новый Структура;
	СтруктураНаКлиенте.Вставить("Ключ2", СтруктураНаКлиенте);
	
КонецПроцедуры
