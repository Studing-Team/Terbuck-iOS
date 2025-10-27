# 터벅 - 한 걸음마다 있는 우리 학교 제휴 혜택

> 우리 학교 근처 제휴 혜택 한눈에! <br> 우리 학교 제휴 혜택 앱, 터벅

<br>

## 📱 AppStore 다운로드

지금 바로 앱 스토어에서 **터벅**을 다운로드하고 우리 학교 제휴 혜택을 확인해 보세요!

[![Download on the App Store](https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg)](https://apps.apple.com/kr/app/%ED%84%B0%EB%B2%85-%EC%9A%B0%EB%A6%AC-%ED%95%99%EA%B5%90-%EC%A0%9C%ED%9C%B4-%ED%98%9C%ED%83%9D/id6747154359)

<br>

## 🗓️ 프로젝트 특징 및 일정 (Project Features and Schedule)

새로운 프로젝트가 아닌 스튜딩 서비스를 리브랜딩하고 핵심기능을 제휴 혜택로 좁혀 타겟팅을 한 서비스 입니다. <br>
기존의 스튜딩 서비스에 대한 내용은 다음 [링크](https://github.com/Studing-Team/Studing-iOS) 를 확인해주세요!

<br>

- 2025.10 ~ 진행중 - 프로젝트 구조 리펙토링 진행중
- 2025.08 ~ 2025.10 - 회원가입 과정에 단과대 설정 기능 추가
- 2025.08 ~ 2025.08 - 지도 모달 관련 제스처 개선 및 버그 해결 (v1.0.2 업데이트)
- 2025.07 ~ 2025.08 - 앱 실행 속도 개선 (v1.0.1 업데이트)
- 2025.07.09 - 앱 출시 (v1.0.0)
- 2025.04 ~ 06 - UI 설계 및 로직 구현
- 2025.03 ~ 04 - 스튜딩 리브랜딩 및 디자인, 프로젝트 초기 설정

<br>

<details>
  <summary>터벅 UI 및 핵심 플로우</summary>
  
  <br>
  
  ![터벅 UI 및 핵심 플로우](https://github.com/user-attachments/assets/13b560ba-76d8-423c-96f9-4f7a32813273)
  
</details>

<br>


## 🚀 시작하기 (Getting Started)

이 프로젝트는 **Tuist** 를 사용하여 프로젝트 모듈과 의존성을 관리합니다. 아래의 가이드를 따라 프로젝트를 설정하고 실행할 수 있습니다.

#### 1. 프로젝트 설정

먼저 프로젝트 저장소를 로컬 환경으로 복제합니다.

```bash
git clone [https://github.com/studing-team/terbuck-ios.git](https://github.com/studing-team/terbuck-ios.git)

cd terbuck-ios/Terbuck
```

프로젝트 폴더로 이동한 후, mise를 사용하여 mise.toml에 명시된 버전의 Tuist와 기타 도구들을 설치합니다

```bash
mise install
```

#### 2. 의존성 설치 및 프로젝트 생성

Tuist를 사용하여 외부 라이브러리(SPM)를 다운로드하고, Terbuck.xcworkspace Xcode 프로젝트 파일을 생성합니다.

```bash
# SPM 의존성(라이브러리)을 다운로드하고 Tuist에 연결합니다.
tuist install

# Xcode 프로젝트 파일을 생성합니다.
tuist generate
```


<br>

## 💻 개발 환경 및 기술 스택 (Development Environment & Tech Stack)
![Platform](https://img.shields.io/badge/platform-iOS%20only-lightgrey?logo=apple)
![Xcode](https://img.shields.io/badge/Xcode-16.2-skyblue)
![iOS](https://img.shields.io/badge/iOS-17.0+-white)
![Tuist](https://img.shields.io/badge/Built%20with-Tuist-4B4B77)

<br>

## 📦 사용한 라이브러리 (Using Libraries)

| Library | Description | Dependency |
|:-----:|:-----:|:-----:|
| [**Firebase**](https://github.com/firebase) | 실시간 푸시 알림을 구현하여 사용자와의 즉각적인 상호작용을 지원합니다 | SPM |
| [**KakaoSDK**](https://github.com/kakao/kakao-ios-sdk) | 카카오 계정을 이용한 OAuth 인증 및 사용자 정보 연동 기능을 구현합니다 | SPM |
| [**Mixpanel-swift**](https://github.com/mixpanel/mixpanel-swift) | 사용자 행동 분석을 통해 데이터 기반의 앱 개선을 가능하게 합니다 | SPM |
| [**NMapsMap**](https://github.com/navermaps/SPM-NMapsMap) | 네이버 지도 SDK를 활용해 고성능 지도 기능과 위치 기반 서비스를 제공합니다 | SPM |
| [**SnapKit**](https://github.com/SnapKit/SnapKit) | AutoLayout을 코드 기반으로 간결하게 설정하며 UI 개발 생산성을 높입니다 | SPM |
| [**Then**](https://github.com/devxoul/Then) | 클로저 기반 인스턴스 초기화를 지원해 코드 가독성과 간결함을 개선합니다 | SPM |
