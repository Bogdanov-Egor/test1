﻿// @strict-types

#Область ПрограммныйИнтерфейс

// См. ОчередьЗаданийПереопределяемый.ПриОпределенииПсевдонимовОбработчиков
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
// 	СоответствиеИменПсевдонимам - см. ОчередьЗаданийПереопределяемый.ПриОпределенииПсевдонимовОбработчиков.СоответствиеИменПсевдонимам
//
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
КонецПроцедуры

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки
//
// Параметры:
//	Типы - см. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.Типы
//
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	
	Типы.Добавить(Метаданные.РегистрыСведений.ОбъектыКОтправке);
	Типы.Добавить(Метаданные.РегистрыСведений.НастройкиУчетныхСистем);
	Типы.Добавить(Метаданные.РегистрыСведений.СостоянияИнтеграцииОбъектов);
	
КонецПроцедуры

// Добавляет объект к отправке во внешнюю учетную систему.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  УчетнаяСистема - ОпределяемыйТип.УчетныеСистемыИнтеграцииОбластейДанных - учетная система.
//  ИдентификаторОбъекта - Строка - идентификатор объекта, должен соответствовать 
//						 требованиям к именованию файлов операционной системы (длина - 50).  
//  Обработчик - Строка - идентификатор обработчика объекта (длина - 50).
//  ДанныеОбъекта - ДвоичныеДанные - данные объекта к отправке (если не указано, данные будут запрошены перед отправкой).
//
Процедура ДобавитьОбъектКОтправке(УчетнаяСистема, ИдентификаторОбъекта,
		Обработчик, ДанныеОбъекта = Неопределено) Экспорт
КонецПроцедуры

// Удаляет объект из объектов к отправке в учетную систему.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  УчетнаяСистема - ОпределяемыйТип.УчетныеСистемыИнтеграцииОбластейДанных - учетная система.
//  ИдентификаторОбъекта - Строка - идентификатор объекта (длина - 50).
//  Обработчик - Строка - идентификатор обработчика объекта (длина - 50).
//
Процедура УдалитьОбъектКОтправке(УчетнаяСистема,
		ИдентификаторОбъекта = Неопределено, Обработчик = Неопределено) Экспорт
КонецПроцедуры

// Выполняет оповещение внешней учетной системы в соответствие с настройками оповещения.
// @skip-warning ПустойМетод - особеннность реализации.
//
// Параметры:
//  УчетнаяСистема - ОпределяемыйТип.УчетныеСистемыИнтеграцииОбластейДанных, СправочникСсылка - учетная система.
//  ИдентификаторОбъекта - Строка - идентификатор объекта (длина - 50).
//  ВызыватьИсключение - Булево - признак вызова исключения при неудачной отправке оповещения.
//
Процедура ОповеститьОбИзмененииОбъекта(УчетнаяСистема, ИдентификаторОбъекта,
		ВызыватьИсключение = Ложь) Экспорт
КонецПроцедуры

// Возвращает настройки внешней учетной системы.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  УчетнаяСистема - ОпределяемыйТип.УчетныеСистемыИнтеграцииОбластейДанных, СправочникСсылка - учетная система.
//  КлючиНастроек - Строка, Массив Из Строка - ключи настроек, по которым нужно вернуть значения.
//
// Возвращаемое значение:
//  Структура - Настройки учетной системы:
//	* ОповещатьОбИзменениях - Булево - признак использования оповещений при создании/изменении данных в приложении.
//	* АдресСервиса - Строка - адрес сервиса приема оповещений об изменениях.
//	* СпособАутентификации - ПеречислениеСсылка.СпособыАутентификации - способ аутентификации в сервисе приема оповещений.
//	* Логин - Строка - логин аутентификации в сервисе приема оповещений (используется при basic-аутентификации).
//	* Пароль - Строка - пароль аутентификации в сервисе приема оповещений (используется при basic-аутентификации).
//	* ИспользоватьСертификат - Булево - признак использования сертификата при установке соединения с сервисом приема оповещений.
//	* ИмяСертификата - Строка - имя файла сертификата.
//	* ПарольСертификата - Строка -  пароль сертификата (используется, если задано свойство ИспользоватьСертификат).
//	* ДанныеСертификата - ДвоичныеДанные - двоичные данные сертификата в base64 (используется, если задано свойство ИспользоватьСертификат).
//	* ПодписыватьДанные - Булево - признак использования подписи данных при отправке их в сервис приема оповещений.
//	* КлючПодписи - Строка - секретное слово, для подписи отправляемых данных. Подпись выполняется с помощью алгоритма HMACSHA256.
//
Функция Настройки(УчетнаяСистема, Знач КлючиНастроек = Неопределено) Экспорт
КонецФункции

// Возвращает шаблон для помещения результатов выполнения команды
// @skip-warning ПустойМетод - особенность реализации.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - шаблон выполнения команды для возврата результатов:
//	* ИдентификаторОбъекта - Строка - идентификатор объекта.
//	* Обработчик - Строка - идентификатор обработчика.
//
Функция НовыйРезультатыВыполненияКоманды() Экспорт
КонецФункции

#Область ОбработчикиОчередиЗаданий

// Выполняет полученную от учетной системы команду.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
//	УчетнаяСистема - ОпределяемыйТип.УчетныеСистемыИнтеграцииОбластейДанных - учетная система.
//	ИдентификаторПараметров - Строка - идентификатор файла параметров выполнения команды (длинна 36).
//
Процедура ВыполнитьКоманду(УчетнаяСистема, ИдентификаторПараметров) Экспорт
КонецПроцедуры

// Формирует пакет данных для получения учетной системой.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//	УчетнаяСистема - ОпределяемыйТип.УчетныеСистемыИнтеграцииОбластейДанных - учетная система
//				   по которой готовятся данные.
//
Процедура ПодготовитьДанные(УчетнаяСистема) Экспорт
КонецПроцедуры

// Обрабатывает полученный от учетной системы пакет данных.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//	УчетнаяСистема - ОпределяемыйТип.УчетныеСистемыИнтеграцииОбластейДанных - учетная система
//				   по которой готовятся данные.
//  ИдентификаторФайла - Строка - идентификатор файла для обработки (длинна 36).
//
Процедура ОбработатьДанные(УчетнаяСистема, ИдентификаторФайла) Экспорт
КонецПроцедуры

#КонецОбласти

#КонецОбласти
