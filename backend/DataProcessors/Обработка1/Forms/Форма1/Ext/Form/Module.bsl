﻿
&НаСервере
Процедура Команда1НаСервере()
	пТекстHTML =  ОписаниеHTML;	
	
	лкВложения = Новый Структура;
	//лкПрефикс = "<img src='data:image/jpeg;base64, ";
	лкПрефикс = "< src='data:image/jpeg;base64, ";
	Пока Найти(пТекстHTML, лкПрефикс) > 0 Цикл
		
		лкНачалоКартинки = Найти(пТекстHTML, лкПрефикс) + СтрДлина(лкПрефикс);
		лкBase64ДанныеКартинки = Сред(пТекстHTML, лкНачалоКартинки);
		лкBase64ДанныеКартинки = Лев(лкBase64ДанныеКартинки, Найти(лкBase64ДанныеКартинки, "'") - 1);
		
		лкКодСоответствия = "_" + СтрЗаменить(Новый УникальныйИдентификатор, "-", "");
		лкКартинка = Новый Картинка(Base64Значение(лкBase64ДанныеКартинки));
		лкВложения.Вставить(лкКодСоответствия, лкКартинка);
		
		//пТекстHTML = СтрЗаменить(пТекстHTML, лкПрефикс + лкBase64ДанныеКартинки + "'",
		//	"<img src='" + лкКодСоответствия + "'");
		пТекстHTML = СтрЗаменить(пТекстHTML, лкПрефикс + лкBase64ДанныеКартинки + "'",
			"< src='" + лкКодСоответствия + "'");
	КонецЦикла;
	
	ФорматированныйДокумент.УстановитьHTML(пТекстHTML, лкВложения);
КонецПроцедуры

&НаКлиенте
Процедура Команда1(Команда)
	Команда1НаСервере();
КонецПроцедуры
