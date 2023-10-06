import Foundation

//Протокол никогда не был использован!
//Проверь, пожалуйста, CalendarViewController.
//Ты кастишь там проперти напрямую при создании, а надо указать тип как протокол.
protocol CalendarViewModelProtocol: AnyObject {
	func configureMembersCalendar()
}

final class CalendarViewModel: CalendarViewModelProtocol {
	
//	Давай сделаем поля приватными.
//	И если они где-то понадобятся как { get } - закроем протоколом.
	var alicesSortedArray = [Int]()
	var bobsSortedArray = [Int]()

//	let hours = Array(9...19)
//	это будет потом сильно проще менять ;)
	let hours = [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
	
	let aliceCalendar = [
		BookedTime(start: 9, end: 12),
		BookedTime(start: 12, end: 13),
		BookedTime(start: 16, end: 19)
	]
	let bobCalendar = [
		BookedTime(start: 10, end: 11),
		BookedTime(start: 12, end: 14),
		BookedTime(start: 14, end: 15),
		BookedTime(start: 16, end: 17)
	]
	
	func configureMembersCalendar() {
		configureAliceCalendar()
		configureBobCalendar()
	}
	
//	Давай представим, что я меняю у aliceCalendar первый BookedTime и второй местами.
//	Твой алгоритм сломается, ведь часы уже будут не отсортированы.
//	Можно попробовать
//	- сортировать [BookedTime] по startTime в начале функции
//	- отсортировать сам массив в конце метода
	private func configureAliceCalendar() {
		for busynessHour in aliceCalendar {
			for i in busynessHour.start ..< busynessHour.end {
				alicesSortedArray.append(i)
			}
		}
	}
	
	private func configureBobCalendar() {
		for busynessHour in bobCalendar {
			for i in busynessHour.start..<busynessHour.end {
				bobsSortedArray.append(i)
			}
		}
	}
}
