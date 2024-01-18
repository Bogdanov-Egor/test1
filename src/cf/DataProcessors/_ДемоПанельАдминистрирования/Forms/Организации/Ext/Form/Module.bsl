﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Обновление состояния элементов.
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОсновнаяОрганизацияПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОсновнаяОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьНесколькоОрганизацийПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	ИмяКонстанты = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если ИмяКонстанты <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, ИмяКонстанты);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	ИмяКонстанты = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	УстановитьДоступность(РеквизитПутьКДанным);
	ОбновитьПовторноИспользуемыеЗначения();
	Возврат ИмяКонстанты;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	ЧастиИмени = СтрРазделить(РеквизитПутьКДанным, ".");
	Если ЧастиИмени.Количество() <> 2 Тогда
		Возврат "";
	КонецЕсли;
	
	ИмяКонстанты = ЧастиИмени[1];
	КонстантаМенеджер = Константы[ИмяКонстанты];
	КонстантаЗначение = НаборКонстант[ИмяКонстанты];
	
	Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
		КонстантаМенеджер.Установить(КонстантаЗначение);
	КонецЕсли;
	
	Возврат ИмяКонстанты;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	КоличествоОрганизаций = Справочники._ДемоОрганизации.КоличествоОрганизаций();
	
	Если РеквизитПутьКДанным = "НаборКонстант._ДемоИспользоватьНесколькоОрганизаций" Или РеквизитПутьКДанным = "" Тогда
		// Флажок нельзя отключить после включения и ввода 2й организации.
		Элементы.ИспользоватьНесколькоОрганизаций.Доступность = Не (КоличествоОрганизаций > 1 И НаборКонстант._ДемоИспользоватьНесколькоОрганизаций);
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант._ДемоОсновнаяОрганизация"
		Или РеквизитПутьКДанным = "НаборКонстант._ДемоИспользоватьНесколькоОрганизаций"
		Или РеквизитПутьКДанным = "" Тогда
		
		// Основную организацию нельзя менять после ее выбора до тех пор пока отключен многофирменный учет.
		Элементы.ОсновнаяОрганизация.ТолькоПросмотр = Не НаборКонстант._ДемоИспользоватьНесколькоОрганизаций
			И ЗначениеЗаполнено(НаборКонстант._ДемоОсновнаяОрганизация);
		
		// Ввести новую организацию можно:
		//   - Когда организаций вообще нет;
		//   - Когда включен многофирменный учет.
		Элементы.ОсновнаяОрганизация.КнопкаСоздания = КоличествоОрганизаций = 0
			Или НаборКонстант._ДемоИспользоватьНесколькоОрганизаций;
		
		// Выбрать другую организацию можно:
		//   - Когда она еще не выбрана;
		//   - Когда включен многофирменный учет.
		Элементы.ОсновнаяОрганизация.КнопкаВыбора = Не ЗначениеЗаполнено(НаборКонстант._ДемоОсновнаяОрганизация)
			Или НаборКонстант._ДемоИспользоватьНесколькоОрганизаций;
		
		// Список быстрого выбора показывается только если есть кнопки создания или выбора.
		Элементы.ОсновнаяОрганизация.КнопкаВыпадающегоСписка = Элементы.ОсновнаяОрганизация.КнопкаСоздания
			Или Элементы.ОсновнаяОрганизация.КнопкаВыбора;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
