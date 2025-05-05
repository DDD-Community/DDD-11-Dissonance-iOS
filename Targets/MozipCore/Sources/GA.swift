//
//  GA.swift
//  MozipCore
//
//  Created by 이원빈 on 1/15/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import FirebaseAnalytics

public struct GA {
  
  public static func logEvent(_ event: Event) {
    Analytics.logEvent(event.rawValue, parameters: nil)
  }
  
  public enum Event: String {
    // 로그인 화면
    case 카카오버튼 = "kakao_login_button_selected"
    case 애플버튼 = "apple_login_button_selected"
    
    // 홈 화면 - 네비게이션바 영역
    case 마이페이지버튼 = "profile_button_selected"
    case 검색버튼 = "search_button_selected"
    
    // 홈 화면 - 스크롤 영역
    case 배너이미지 = "banner_image_selected"
    case 공모전더보기버튼 = "contest_more_selected"
    case 교육더보기버튼 = "education_more_selected"
    case IT동아리더보기버튼 = "it_club_more_selected"
    
    // 공고 리스트 - 상단 카테고리 칩
    case 전체칩 = "contest_all_chip_selected"
    case 개발칩 = "contest_develop_chip_selected"
    case 디자인칩 = "contest_design_chip_selected"
    case 기획아이디어칩 = "contest_idea_chip_selected"
    
    // 공고 리스트 - 정렬버튼
    case 정렬버튼 = "array_menu_selected"
    case 최신순버튼 = "latest_array_selected"
    case 마감순버튼 = "oldest_array_selected"
    
    // 공고 상세
    case 지원하기버튼 = "apply_button_selected"
    case 공유버튼 = "share_button_selected"
  }
}
