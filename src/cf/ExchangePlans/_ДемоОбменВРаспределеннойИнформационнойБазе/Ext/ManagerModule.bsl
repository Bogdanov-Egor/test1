﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ОбменДанными

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Настройки.НазначениеПланаОбмена = "РИБСФильтром";
	
	// Для целей автоматического тестирования обновления в рамках РИБ в разных режимах
	// определяем назначение плана обмена по наличию фильтров по организациям.
	ПараметрЗапускаПриложения = ПараметрыСеанса.ПараметрыКлиентаНаСервере.Получить("ПараметрЗапуска");
	Если СтрНайти(ПараметрЗапускаПриложения, "РежимОтладки") > 0 Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ОрганизацииИзУзла.Организация КАК Организация
		|ИЗ
		|	ПланОбмена._ДемоОбменВРаспределеннойИнформационнойБазе.Организации КАК ОрганизацииИзУзла
		|ГДЕ
		|	НЕ ОрганизацииИзУзла.Ссылка.ЭтотУзел
		|	И НЕ ОрганизацииИзУзла.Ссылка.ПометкаУдаления";
		Если Запрос.Выполнить().Пустой() Тогда
			Настройки.НазначениеПланаОбмена = "РИБ";
		КонецЕсли;
	КонецЕсли;
	
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	
	Настройки.Алгоритмы.ПриСохраненииНастроекСинхронизацииДанных = Истина;

КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию
//  ИдентификаторНастройки - Строка - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт
	
	КраткаяИнформацияПоОбмену = НСтр("ru = 'Распределенная информационная база представляет собой иерархическую структуру, 
	|состоящую из отдельных информационных баз системы 1С:Предприятие - узлов распределенной информационной базы, между 
	|которыми организована синхронизация конфигурации и данных. Главной особенностью распределенных информационных баз 
	|является передача изменений конфигурации в подчиненные узлы. 
	|Имеется возможность настраивать ограничения миграции данных, например по организациям.'");
	КраткаяИнформацияПоОбмену = СтрЗаменить(КраткаяИнформацияПоОбмену, Символы.ПС, "");
	
	ПодробнаяИнформацияПоОбмену = "https://its.1c.ru/bmk/bsp/sync_ib";
	
	ОписаниеВарианта.КраткаяИнформацияПоОбмену   = КраткаяИнформацияПоОбмену;
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену = ПодробнаяИнформацияПоОбмену;
	
	ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = НСтр("ru = 'Распределенная информационная база'");
	
	ОписаниеВарианта.ИмяФормыПомощникаНастройкиСинхронизацииДанных =
		"ПланОбмена._ДемоОбменВРаспределеннойИнформационнойБазе.Форма.ПомощникНастройкиСинхронизацииДанных";
	
	ОписаниеВарианта.ОбщиеДанныеУзлов = "ДатаНачалаВыгрузкиДокументов, ИспользоватьОтборПоОрганизациям, Организации";
	
КонецПроцедуры

// Заполняет узел обмена настройками отправки и получения данных (ограничения передачи данных и значения по умолчанию).
//
// Параметры:
//  Корреспондент - ПланОбменаОбъект - узел плана обмена, соответствующий корреспонденту.
//  ДанныеЗаполнения - Структура - структура с данными для заполнения настроек отправки и получения данных.
//
Процедура ПриСохраненииНастроекСинхронизацииДанных(Корреспондент, ДанныеЗаполнения) Экспорт
	
	ЗаполнитьЗначенияСвойств(Корреспондент, ДанныеЗаполнения, 
		"ДатаНачалаВыгрузкиДокументов,
		|ИспользоватьОтборПоОрганизациям,
		|ИспользоватьОтборПоСкладам,
		|ИспользоватьОтборПоПодразделениям");
	
	Корреспондент.Организации.Загрузить(ДанныеЗаполнения.Организации);
	Корреспондент.Склады.Загрузить(ДанныеЗаполнения.Склады);
	Корреспондент.Подразделения.Загрузить(ДанныеЗаполнения.Подразделения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбменДанными

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("РегистрироватьИзменения");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#КонецЕсли
