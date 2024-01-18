﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка._ДемоПоступлениеТоваров") Тогда
		ХозяйственнаяОперация = Перечисления._ДемоХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику;
		Сумма = ДанныеЗаполнения.АгентскиеУслуги.Итог("Сумма");
		Для Каждого СтрокаТаблицы Из ДанныеЗаполнения.Товары Цикл
			Сумма = Сумма + СтрокаТаблицы.Цена * СтрокаТаблицы.Количество;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли