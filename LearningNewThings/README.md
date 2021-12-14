
// Two Circles and a text "Hello World" in the center
Text("Hello World")
    .frame(width: 100, height: 100, alignment: .center)
    .background(
        Circle()
            .fill(Color.blue)
    )
    .frame(width: 120, height: 120, alignment: .center)
    .background(
        Circle()
            .fill(Color.red)
    )
    
// Same as code above, but using overlay instead of background
Circle()
    .fill(Color.red)
    .frame(width: 120, height: 120, alignment: .center)
    .overlay(
        Circle()
            .fill(Color.blue)
            .frame(width: 100, height: 100, alignment: .center)
            .overlay(
                Text("Hello World")
            )
    )

// Also, there are alignment properties for overlay and background as well
Rectangle()
    .frame(width: 100, height: 100)
    .overlay(
        Rectangle()
            .fill(Color.blue)
            .frame(width: 50, height: 50),
        alignment: .topLeading
    )
    .background(
        Rectangle()
            .fill(Color.red)
            .frame(width: 150, height: 150),
        alignment: .bottomTrailing
    )

Image(systemName: "heart.fill")
    .font(.system( ))

세종이 꿈꾼 나라

풍요롭고 행복한 나라를 만들기 위해 세계적인 학문 · 언어 · 발명품을 남긴 세종대왕의 시작은 범상치 않았다 -> (차후 왕위를 선정하는 과정에서 태종은 나라를 바로 세우겠다는 의지가 나타나는 듯 하다) 
태종은 적장자 상속 원칙 아래 사랑하는 양녕대군을 세자로 택하게 되었다. 
양녕대군은 사춘기에 접어들 무렵, 유난히 영특했던 충령대군과 평범한 효령대군과 다르게 문란하고 오락을 사랑하는 모습을 꾸준히 보였으며, 
태종의 막내 아들 성녕대군이 병이 나게 되었을 때에도 양녕대군은 신경을 쓰지 않는 모습을 보이게 된다. 
성녕대군의 죽음으로 인해 태종이 깊은 슬픔에 빠지게 되었으나, 앙녕대군은 활쏘기와 사냥과 같은 오락 중심 삶을 지속하고 있었다.
양녕대군의 비상식적인 처신과 대비되는 태종의 셋째 아들, 충령대군은 우애스럽고 온화한 모습을 의서를 읽어 약을 지어주거나 직접 간호함을 통해 보여주었다.
이런 충녕대군의 됨됨이를 본 남재는 여러 사람이 있는 자리에서 충녕대군이 왕이 되기를 원한다는 말투를 건내게 되었다. 
이런 불리한 상황에도 불구하고, 양녕대군은 '어리'라는 남의 첩을 탐하고 이러한 첩을 운반하는 역할을 맡은 김한로를 외방에 유배를 보냈을 때에 되려 무례한 상서를 올리게 되니,
왕비인 원경황후 마저도 충녕의 어짊을 칭찬하고 양녕의 부적당함을 지적하게 되었다. 양녕대군의 비상식적이며 난잡한 행실로 인해, 태종은 양녕이 장차 왕이 되는 것에 대한 마음을 단념하게 되었다.
물론, 충령에게는 맡형인 효령대군이 있었으나, 나라의 근본을 세우는 과업에 있어서 평범하고 술자리 조차 거부하는 효령은 마땅치 않은 선택지로 보였고, 
총명하고 민첩하며 학문을 좋아하고 사교적이기도 한 충녕대군을 새로운 세자로 삼게되었다. 이에, 양녕(이제)은 광주로 추방을 했다.

 

/ 효령대군 / 충령대군 이야기 요약
비인습적으로, 태종이 세종을 선택해 왕위에 오르며, 참 백성중심 정치를 시작하게 된다.

   
