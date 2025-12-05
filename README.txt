Это расширенный ERC-20 токен с дополнительной функциональностью отправки и хранения сообщений. Контракт объединяет стандартные возможности криптовалютного токена с системой уведомлений/комментариев.

1. Хранение данных
Публичные переменные:

transferHistory[] - массив всех переводов с сообщениями

balanceOf - балансы пользователей

allowance - разрешения на расходование

owner - владелец контракта

Приватные переменные:

lastMessage - последнее отправленное сообщение

lastTransferWithMessage - последний перевод с сообщением

2. События (Events)
Transfer - стандартное + расширенное с сообщением

Approval - подтверждение расходов

MessageSent - отправка отдельного сообщения

TransferWithMessageEvent - перевод с сообщением

Основные функции
Переводы токенов
transfer(to, amount) - стандартный перевод ERC-20

transferWithMessage(to, amount, message) - перевод с комментарием

transferFrom(from, to, amount) - перевод от имени другого адреса

transferFromWithMessage(from, to, amount, message) - делегированный перевод с комментарием

Работа с сообщениями
sendMessage(message) - отправить только сообщение

getLastMessage() - получить последнее сообщение

getLastTransferWithMessage() - получить последний перевод с деталями

getLastMessageAndTransfer() - комбинированные данные

История переводов
transferHistory[index] - доступ к конкретному переводу

getTransferHistoryCount() - количество переводов в истории

getTransferWithMessage(index) - получение перевода по индексу
