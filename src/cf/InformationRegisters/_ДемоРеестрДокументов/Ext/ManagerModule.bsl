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

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	(ЗначениеРазрешено(Организация) 
	|	ИЛИ Партнер = ЗНАЧЕНИЕ(Справочник._ДемоОрганизации.ПустаяСсылка)
	|	) И( ЗначениеРазрешено(Партнер)
	|	ИЛИ Партнер = ЗНАЧЕНИЕ(Справочник._ДемоПартнеры.ПустаяСсылка)
	|	) И ( ЗначениеРазрешено(Подразделение)
	|	ИЛИ Подразделение = ЗНАЧЕНИЕ(Справочник._ДемоПодразделения.ПустаяСсылка)
	|	) И ( ЗначениеРазрешено(МестоХранения)
	|	ИЛИ МестоХранения = ЗНАЧЕНИЕ(Справочник._ДемоМестаХранения.ПустаяСсылка)
	|	) И ЧтениеСпискаРазрешено(ТипСсылки)";

КонецПроцедуры
// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли
