﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("БазаПодключена") Тогда
		БазаПодключена = Параметры.БазаПодключена;
	КонецЕсли;
	
	Если БазаПодключена Тогда
		
		ДанныеНастроекИнтеграцииСУСП = ИнформационныйЦентрСервер.ДанныеНастроекИнтеграцииСУСП();
		АдресУСП = ДанныеНастроекИнтеграцииСУСП.АдресВнешнегоАнонимногоИнтерфейсаУСП;
		Email = ДанныеНастроекИнтеграцииСУСП.АдресПочтыАбонентаДляИнтеграцииСУСП;
		
		Элементы.ДекорацияИнформация.Заголовок = НСтр("ru='Информационная база подключена к службе поддержки со следующими параметрами:'");
		
		ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
		
		ПараметрыЗадания = ДлительныеОперации.ВыполнитьВФоне(
			"ИнформационныйЦентрСервер.ОпределитьСостояниеПодключенияВФоне", , ПараметрыВыполнения);
		
		Элементы.ЗначокСостояниеПодключения.Картинка = БиблиотекаКартинок.ДлительнаяОперация16;
		
	Иначе
		
		Элементы.ДекорацияИнформация.Заголовок = НСтр("ru='Информационная база не подключена к службе поддержки. Подключить базу можно сейчас.'");
		
		Email = ПользователиСлужебный.ОписаниеПользователя(Пользователи.АвторизованныйПользователь()).АдресЭлектроннойПочты;
		СведенияОбИБ = ИнформационныйЦентрСервер.СведенияОбИБДляИнтеграции();
		ИмяКонфигурации = СведенияОбИБ.ИмяКонфигурации;
		ВерсияКонфигурации = СведенияОбИБ.ВерсияКонфигурации;
		ВерсияПлатформы = СведенияОбИБ.ВерсияПлатформы;
		ИдентификаторКлиента = СведенияОбИБ.ИдентификаторКлиента;
		ИдентификаторИБ = СведенияОбИБ.ИдентификаторИБ;
		
	КонецЕсли;
	
	Элементы.КодРегистрации.Видимость = Не БазаПодключена;
	Элементы.ВвестиКодРегистрации.Видимость = Не БазаПодключена;
	Элементы.ПерейтиНаСтраницуРегистрации.Видимость = Не БазаПодключена;
	Элементы.ОтменитьПодключение.Видимость = БазаПодключена;
	Элементы.АдресУСП.ТолькоПросмотр = БазаПодключена;
	Элементы.Email.ТолькоПросмотр = БазаПодключена;
	Элементы.ГруппаСостояниеПодключения.Видимость = БазаПодключена;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если БазаПодключена Тогда
		ПодключитьОбработчикОжидания("ОпределитьСостояниеПодключенияВФонеОжидание", 1, Истина);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиНаСтраницуРегистрации(Команда)
	
	Если Не ЗначениеЗаполнено(АдресУСП) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru='Необходимо указать адрес службы поддержки'"), , "АдресУСП");
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Email) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru='Необходимо указать e-mail пользователя'"), , "Email");
		Возврат;
	КонецЕсли;
	
	ШаблонАдресаСтраницы = "%1/v1/StartLocalRegistration?email=%2&appname=%3&appversion=%4&platf=%5&ibid=%6&clid=%7";
	СсылкаНаСтраницу = СтрШаблон(ШаблонАдресаСтраницы, 
		АдресУСП, Email, ИмяКонфигурации, ВерсияКонфигурации, ВерсияПлатформы, ИдентификаторИБ, ИдентификаторКлиента);
	
	#Если ВебКлиент Тогда
		ПерейтиПоНавигационнойСсылке(СсылкаНаСтраницу);
	#Иначе
		ЗапуститьПриложение(СсылкаНаСтраницу);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ВвестиКодРегистрации(Команда)
	Результат = ВвестиКодРегистрацииНаСервере();
	Если Не Результат.Успешно Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.ТекстСообщения);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКОбращениям(Команда)
	
	Закрыть();
	ИнформационныйЦентрКлиент.ОткрытьОбращенияВСлужбуПоддержки();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПодключение(Команда)

	Оповещение = Новый ОписаниеОповещения("ОтменитьПодключениеПриПроверкеОтвета", ЭтаФорма);
	
	ТекстВопроса = НСтр("ru = 'После отмены подключения работа с обращениями в службу поддержки будет невозможна. Продолжить?'");
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ВвестиКодРегистрацииНаСервере()
	
	Результат = новый Структура;
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("Успешно", Ложь);
	
	АдресСервиса = АдресУСП + "/v1/FinishLocalRegistration";
	
	Попытка
		
		СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресСервиса);
		Хост = СтруктураURI.Хост;
		ПутьНаСервере = СтруктураURI.ПутьНаСервере;
		Порт = СтруктураURI.Порт;
		
		Если НРег(СтруктураURI.Схема) = НРег("https") Тогда
			ЗащищенноеСоединение = 
				ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение(, Новый СертификатыУдостоверяющихЦентровОС);
		Иначе
			ЗащищенноеСоединение = Неопределено;
		КонецЕсли;
		
		Соединение = Новый HTTPСоединение(
			Хост,
			Порт,
			,
			,
			,
			,
			ЗащищенноеСоединение);
		
		ДанныеЗапроса = Новый Структура;
		ДанныеЗапроса.Вставить("email", Email);
		ДанныеЗапроса.Вставить("appname", ИмяКонфигурации);
		ДанныеЗапроса.Вставить("appversion", ВерсияКонфигурации);
		ДанныеЗапроса.Вставить("platf", ВерсияПлатформы);
		ДанныеЗапроса.Вставить("ibid", ИдентификаторИБ);
		ДанныеЗапроса.Вставить("clid", ИдентификаторКлиента);
		ДанныеЗапроса.Вставить("code", КодРегистрации);
		ДанныеЗапроса.Вставить("method_name", "FinishLocalRegistration");
		
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();
		ЗаписатьJSON(ЗаписьJSON, ДанныеЗапроса);
		
		СтрокаЗапроса = ЗаписьJSON.Закрыть();
		
		Заголовки = Новый Соответствие;
		Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
		Заголовки.Вставить("Accept", "application/json");
		
		Запрос = Новый HTTPЗапрос(ПутьНаСервере, Заголовки);
		Запрос.УстановитьТелоИзСтроки(СтрокаЗапроса);
		
		Ответ = Соединение.ОтправитьДляОбработки(Запрос);
		
		Если Ответ.КодСостояния <> 200 Тогда
			
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Ошибка %1'", ОбщегоНазначения.КодОсновногоЯзыка()), Строка(Ответ.КодСостояния));
			ЗафиксироватьОшибку(Результат, ТекстОшибки);
			Возврат Результат;
			
		КонецЕсли;
		
		ЧтениеJSON = Новый ЧтениеJSON;
		
		СтрокаТелаОтвета = Ответ.ПолучитьТелоКакСтроку();
		ЧтениеJSON.УстановитьСтроку(СтрокаТелаОтвета);
		
		Попытка
			ДанныеОтвета = ПрочитатьJSON(ЧтениеJSON, Ложь);	
		Исключение
			ЗафиксироватьОшибку(Результат, СтрокаТелаОтвета);
			Возврат Результат;
		КонецПопытки;
		
		Если Не ДанныеОтвета.success Тогда
			ЗафиксироватьОшибку(Результат, ДанныеОтвета.response_text);
			Возврат Результат;
		КонецЕсли;
		
		АдресИнформационногоЦентра = ДанныеОтвета.info_center_address;
		
		ПриУспешномВводеКодаРегистрации();
		
		Результат.Успешно = Истина;
		Возврат Результат;
		
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		ЗафиксироватьОшибку(Результат, 
			ИнформационныйЦентрСлужебный.ПодробныйТекстОшибки(ИнформацияОбОшибке), 
			ИнформационныйЦентрСлужебный.КраткийТекстОшибки(ИнформацияОбОшибке));
			
		Возврат Результат;
		
	КонецПопытки;
	
КонецФункции

&НаСервере
Процедура ЗафиксироватьОшибку(Результат, ПодробныйТекстОшибки, Знач КраткийТекстОшибки = "")
	
	Если Не ЗначениеЗаполнено(КраткийТекстОшибки) Тогда
		КраткийТекстОшибки = ПодробныйТекстОшибки;
	КонецЕсли;
	
	Результат.Успешно = Ложь;
	Результат.ТекстСообщения = КраткийТекстОшибки;
	
	ЗаписьЖурналаРегистрации(
		СтрШаблон("%1.%2", ИмяСобытияЖурналаРегистрации(), 
			НСтр("ru = 'Ввод кода регистрации'", ОбщегоНазначения.КодОсновногоЯзыка())),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ПодробныйТекстОшибки);
				
	Результат.Успешно = Ложь;
	Результат.ТекстСообщения = КраткийТекстОшибки;
	
КонецПроцедуры

&НаСервере
Процедура ПриУспешномВводеКодаРегистрации()
	
	Элементы.ДекорацияУспешноеПодключение.Заголовок = СтрЗаменить(
		Элементы.ДекорацияУспешноеПодключение.Заголовок,
		"[Email]",
		Email);
	
	ИнформационныйЦентрСервер.ЗаписатьДанныеНастроекИнтеграцииСУСП(
		АдресУСП,
		Истина,
		Email,
		КодРегистрации,
		АдресИнформационногоЦентра);
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаУспешноеПодключение;
	
КонецПроцедуры

&НаСервере
Функция ИмяСобытияЖурналаРегистрации()
	
	Возврат ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации();
	
КонецФункции

&НаКлиенте
Процедура ОпределитьПоддерживаемыеБазыВФонеЗавершение(Операция, ДополнительныеПараметры) Экспорт
	
	Если Операция.Статус = "Выполнено" Тогда
		
		Результат = ПолучитьИзВременногоХранилища(Операция.АдресРезультата);
		
		Если Результат.Успешно Тогда
			Элементы.НадписьСостояниеПодключения.Заголовок = НСтр("ru='Подключено'");
			Элементы.ЗначокСостояниеПодключения.Картинка = БиблиотекаКартинок.ОформлениеЗнакФлажок;
		Иначе
			Элементы.НадписьСостояниеПодключения.Заголовок = НСтр("ru='Ошибка подключения: '") + Результат.ТекстСообщения;
			Элементы.ЗначокСостояниеПодключения.Картинка = БиблиотекаКартинок.ОформлениеЗнакВоcклицательныйЗнак;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОпределитьСостояниеПодключенияВФонеОжидание()
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	Обработчик = Новый ОписаниеОповещения("ОпределитьПоддерживаемыеБазыВФонеЗавершение", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ПараметрыЗадания, Обработчик, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьПодключениеНаСервере()
	
	ИнформационныйЦентрСервер.ОчиститьДанныеНастроекИнтеграцииСУСП();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПодключениеПриПроверкеОтвета(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОтменитьПодключениеНаСервере();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
