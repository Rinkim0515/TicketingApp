//
//  SearchVC.swift
//  GGV
//
//  Created by KimRin on 5/19/25.
//


import UIKit
import SnapKit
import Kingfisher
import Combine

final class SearchVC: UIViewController {
    private let movieSearchView = SearchView()
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: MovieSearchVM
    //MARK: - lifeCycle
    init(viewModel: MovieSearchVM){ //@MainActor에 대한 부분 찾아봐야함
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
            }
    
    
}
