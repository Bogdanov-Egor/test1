﻿#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание типа значения дополнительного свойства по имени
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИмяТипа	- Строка - имя типа значения дополнительного свойства.
// 
// Возвращаемое значение:
//  ОписаниеТипов - описание типа значения.
Функция ТипЗначенияДополнительногоСвойстваПоИмени(ИмяТипа) Экспорт

	Если ИмяТипа = "string" Тогда
		Возврат Новый ОписаниеТипов("Строка");
	ИначеЕсли ИмяТипа = "decimal" Тогда
		Возврат Новый ОписаниеТипов("Число");
	ИначеЕсли ИмяТипа = "date" Тогда
		Возврат Новый ОписаниеТипов("Дата",,,,, ЧастиДаты.ДатаВремя);
	ИначеЕсли ИмяТипа = "boolean" Тогда
		Возврат Новый ОписаниеТипов("Булево");
	ИначеЕсли ИмяТипа = "subscriber" Тогда
		Возврат Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(12, 0, ДопустимыйЗнак.Неотрицательный));
	ИначеЕсли ИмяТипа = "service" Тогда
		Возврат ОписаниеТипаСтрока(9);
	ИначеЕсли ИмяТипа = "additional_value" Тогда
		Возврат ОписаниеТипаСтрока(255);
	ИначеЕсли ИмяТипа = "additional_value_group" Тогда
		Возврат ОписаниеТипаСтрока(255);
	ИначеЕсли ИмяТипа = "tariff" Тогда
		Возврат ОписаниеТипаСтрока(9);
	ИначеЕсли ИмяТипа = "service_provider_tariff" Тогда
		Возврат ОписаниеТипаСтрока(9);
	ИначеЕсли ИмяТипа = "user" Тогда
		Возврат ОписаниеТипаСтрока(32);
	ИначеЕсли ИмяТипа = "tariff_period" Тогда
		Возврат ОписаниеТипаСтрока(10);
	ИначеЕсли ИмяТипа = "subscription" Тогда
		Возврат ОписаниеТипаСтрока(9);
	Иначе
		Возврат Тип("Неопределено");
	КонецЕсли;

КонецФункции

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Функция ОписаниеТипаСтрока(ДлинаСтроки)
	
	Возврат Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(ДлинаСтроки, ДопустимаяДлина.Переменная));
	
КонецФункции

#КонецОбласти 