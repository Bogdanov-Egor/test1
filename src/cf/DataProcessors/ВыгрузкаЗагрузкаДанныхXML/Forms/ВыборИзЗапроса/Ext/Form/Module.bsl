﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПараметрыЗапросаЭтоВыражениеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ПараметрыЗапроса.ТекущиеДанные;
	
	Если ТекущиеДанные.ЭтоВыражение И Не ТипЗнч(ТекущиеДанные.ЗначениеПараметра) = Тип("Строка") Тогда
		ТекущиеДанные.ЗначениеПараметра = "";
	КонецЕсли;
	
	ИзменитьВыборТипа();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьЗапрос(Команда)
	
	ТекстЗапроса = ДокументТекстЗапроса.ПолучитьТекст();
	
	Если ПустаяСтрока(ТекстЗапроса) Тогда
		
		СообщитьПользователю(НСтр("ru = 'Не задан текст запроса'"), "ТекстЗапроса");
		Возврат;
		
	КонецЕсли;
	
	ВыполнитьЗапросНаСервере(ТекстЗапроса);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПараметры(Команда)
	ЗаполнитьПараметрыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВРезультатВыгрузки(Команда)
	
	Если Элементы.Найти("РезультатЗапроса") = Неопределено Тогда
		
	Иначе
		
		ОповеститьОВыборе(ЭтотОбъект.РезультатЗапроса);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВыполнитьЗапросНаСервере(ТекстЗапроса)
	
	Запрос = Новый Запрос;
	
	Для каждого СтрокаПараметров Из ПараметрыЗапроса Цикл
		Если СтрокаПараметров.ЭтоВыражение Тогда
			Запрос.УстановитьПараметр(СтрокаПараметров.ИмяПараметра, ВычислитьВыражение(СтрокаПараметров.ЗначениеПараметра));
		Иначе
			Запрос.УстановитьПараметр(СтрокаПараметров.ИмяПараметра, СтрокаПараметров.ЗначениеПараметра);
		КонецЕсли;
	КонецЦикла;
	
	Запрос.Текст = ТекстЗапроса;
	Результат = Запрос.Выполнить();
	ТаблицаРезультата = Результат.Выгрузить();
	
	УдалитьЭлементыФормы();
	ДобавитьЭлементыФормы(ТаблицаРезультата);
	
КонецПроцедуры

&НаСервере
Функция ВычислитьВыражение(Знач Выражение)
	
	УстановитьБезопасныйРежим(Истина);
	
	Для Каждого ОбщийРеквизит Из Метаданные.ОбщиеРеквизиты Цикл
		Если ОбщийРеквизит.РазделениеДанных = Метаданные.СвойстваОбъектов.РазделениеДанныхОбщегоРеквизита.Разделять Тогда
			УстановитьБезопасныйРежимРазделенияДанных(ОбщийРеквизит.Имя, Истина);
		КонецЕсли;
	КонецЦикла;
	
	// Вызов ВычислитьВБезопасномРежиме не требуется, т.к. безопасный режим устанавливается без использования средств БСП.
	Возврат Вычислить(Выражение);
	
КонецФункции

&НаСервере
Процедура ДобавитьЭлементыФормы(ТаблицаРезультата)
	
	ИмяРеквизита = "РезультатЗапроса";
	
	МассивРеквизитов = Новый Массив;
	МассивРеквизитов.Добавить(Новый РеквизитФормы(ИмяРеквизита, Новый ОписаниеТипов("ТаблицаЗначений")));
	
	Для Каждого Колонка Из ТаблицаРезультата.Колонки Цикл
		МассивРеквизитов.Добавить(Новый РеквизитФормы(Колонка.Имя, Колонка.ТипЗначения, ИмяРеквизита));
	КонецЦикла;
	
	ИзменитьРеквизиты(МассивРеквизитов);
	
	ТаблицаФормы = Элементы.Добавить(ИмяРеквизита, Тип("ТаблицаФормы"), Элементы.ГруппаРезультатЗапроса);
	ТаблицаФормы.ПутьКДанным = ИмяРеквизита;
	ТаблицаФормы.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
	ТаблицаФормы.РастягиватьПоВертикали = Ложь;
	
	Для Каждого Колонка Из ТаблицаРезультата.Колонки Цикл
		НовыйЭлемент = Элементы.Добавить("Колонка_" + Колонка.Имя, Тип("ПолеФормы"), ТаблицаФормы);
		НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
		НовыйЭлемент.ПутьКДанным = ИмяРеквизита + "." + Колонка.Имя;
	КонецЦикла; 
	
	ЗначениеВРеквизитФормы(ТаблицаРезультата, ИмяРеквизита);
	
	Элементы.ГруппаРезультатаЗапроса.ТекущаяСтраница = Элементы.ГруппаРезультатаЗапроса.ПодчиненныеЭлементы.ГруппаРезультатЗапроса;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьЭлементыФормы()
	
	ИмяРеквизита = "РезультатЗапроса";
	
	Если Элементы.Найти(ИмяРеквизита) <> Неопределено Тогда
		
		МассивРеквизитов = Новый Массив;
		МассивРеквизитов.Добавить(ИмяРеквизита);
		
		ИзменитьРеквизиты(, МассивРеквизитов);
		
		Элементы.Удалить(Элементы[ИмяРеквизита]);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СообщитьПользователю(Текст, ПутьКДанным = "")
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = Текст;
	Сообщение.ПутьКДанным = ПутьКДанным;
	Сообщение.Сообщить();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = ДокументТекстЗапроса.ПолучитьТекст();
	
	ОписаниеПараметров = Запрос.НайтиПараметры();
	
	Для Каждого Параметр Из ОписаниеПараметров Цикл
		ИмяПараметра =  Параметр.Имя;
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("ИмяПараметра", ИмяПараметра);
		МассивСтрок = ПараметрыЗапроса.НайтиСтроки(ПараметрыОтбора);
		
		Если МассивСтрок.Количество() = 1 Тогда
			
			СтрокаПараметров = МассивСтрок[0];
			
		Иначе
			
			СтрокаПараметров = ПараметрыЗапроса.Добавить();
			СтрокаПараметров.ИмяПараметра = ИмяПараметра;
			
		КонецЕсли;
		
		СтрокаПараметров.ЗначениеПараметра = Параметр.ТипЗначения.ПривестиЗначение(СтрокаПараметров.ЗначениеПараметра);
		СтрокаПараметров.ТипПараметра = Параметр.ТипЗначения;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыборТипа()
	
	ТекущиеДанные = Элементы.ПараметрыЗапроса.ТекущиеДанные;
	ПараметрЗапроса = Элементы.ПараметрыЗапроса.ПодчиненныеЭлементы.ПараметрыЗапросаЗначениеПараметра;
	
	ПараметрЗапроса.ОграничениеТипа = ?(ТекущиеДанные.ЭтоВыражение, Новый ОписаниеТипов, ТекущиеДанные.ТипПараметра);
	ПараметрЗапроса.ВыбиратьТип = Не ТекущиеДанные.ЭтоВыражение;
	
КонецПроцедуры

#КонецОбласти
