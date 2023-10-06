// MARK: - Сделал ревью кода в виде комментов, потому что обычные комменты не видно в публичном пр

import UIKit

final class CalendarViewController: UIViewController {
	
	let calendarViewModel = CalendarViewModel()
	
//	В отличие от IBOutlets, тут нам не нужно использовать forceUnwrap.
//	Давай попробуем 2 варианта:
//
//	- Перепишем все на lazy var
//	- Сделаем let переменную и все конфигурацию вынесем в отдельную функцию
//	forceUnwrap - особенно internal - 99.9% приведет к крашу.
	var scrollView: UIScrollView!
	var containerView: View!
	var alisaCollectionView: UICollectionView!
	var bobCollectionView: UICollectionView!
	var matchesCollectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
//		Создаем memory leak!
//		[weak self] in нужно добавить в кложуру
//		Почитай, пожалуйста, про strong reference cycle и ARC - если будут вопросы, можешь задать в личку.
		DispatchQueue.main.async {
			self.makeUI()
		}
//		Конфигурация модельки происходит после makeUI.
//		Мы точно готовы к такому поведению? Может быть, стоит попробовать сначала приготовить вью, а потом - apply-ить к ней модельку?
		calendarViewModel.configureMembersCalendar()
	}
}
	
// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension CalendarViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//	Если мы делаем MVVM, то почему Controller берет на себя роль сущности, которая решает количество ячеек (тем более константно) - давай вынесем это в Model сущность, и количество будет вычиститься на основе array.
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		11
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//		Не видел, чтобы мы регистрировали ячейку для нашей коллекции - словим рантайм краш :(
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssistantCollectionViewCell.cellID, for: indexPath) as? AssistantCollectionViewCell else { return UICollectionViewCell() }
		
//		Почитай про DRY
//		Давай сначала делать все ячейки по дефолту серыми, а по итогам конфигурации, если нужно - будем менять.
		if collectionView == alisaCollectionView {
			cell.makeBackgorundColor(color: .systemBlue)
			if !calendarViewModel.alicesSortedArray.contains(calendarViewModel.hours[indexPath.row]) {
				cell.makeBackgorundColor(color: .systemGray)
			}

//			Есть принципиальная разница между == и ===
//			Вполне возможно, что система решит, что все эти коллекции равны по своим внутренностям, но они в нашей логики не одинаковы. Поэтому правильней было бы их сравнивать по pointer-у.
		} else if collectionView == bobCollectionView {
			cell.makeBackgorundColor(color: .systemOrange)
			if !calendarViewModel.bobsSortedArray.contains(calendarViewModel.hours[indexPath.row]) {
				cell.makeBackgorundColor(color: .systemGray)
			}
		} else if collectionView == matchesCollectionView {
			cell.makeBackgorundColor(color: .systemRed)
			if !calendarViewModel.alicesSortedArray.contains(calendarViewModel.hours[indexPath.row]) && !calendarViewModel.bobsSortedArray.contains(calendarViewModel.hours[indexPath.row]) {
				cell.makeBackgorundColor(color: .systemGreen)
			}
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 90, height: 50)
	}
}
