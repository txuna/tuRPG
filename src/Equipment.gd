extends Node

const EQUIPMENT = 1
const CONSUMPTION = 2
const ETC = 3

const ONE_HAND = 10 # 한손검 
const TWO_HAND = 11 # 두손검 
const BOW = 12
const CROSS_BOW = 13
const WAND = 14
const STAFF = 15

const WEAPON = 1
const HAT = 2 
const SHIRT = 3 
const PANTS = 4
const SHOES = 5
const EARRING = 6
const RING = 7
const BELT = 8
const CLOAK = 9

const PHYSICAL = 1 
const MAGIC = 2

#enum {ZERO_OPTION, FIRST_OPTION, SECOND_OPTION, THIRD_OPTION, FOURTH_OPTION, FIFTH_OPTION, SIXTH_OPTION, SEVENTH_OPTION}
const ZERO_OPTION = 0 
const SEVENTH_OPTION = 1 
const SIXTH_OPTION = 2
const FIFTH_OPTION = 3
const FOURTH_OPTION = 4
const THIRD_OPTION = 5
const SECOND_OPTION = 6
const FIRST_OPTION = 7

const additional_option = {
	FIRST_OPTION : {
		"percent" : 0.1, 
		"string" : "7",
		"value" : 5
	}, 
	SECOND_OPTION : {
		"percent" : 1.5, 
		"string" : "6",
		"value" : 3
	}, 
	THIRD_OPTION : {
		"percent" : 5.0, 
		"string" : "5",
		"value" : 2.5
	}, 
	FOURTH_OPTION : {
		"percent" : 10.5, 
		"string" : "4",
		"value" : 2.0
	}, 
	FIFTH_OPTION : {
		"percent" : 15.0, 
		"string" : "3",
		"value" : 1.5
	}, 
	SIXTH_OPTION : {
		"percent" : 30.0, 
		"string" : "2",
		"value" : 1.0
	},
	SEVENTH_OPTION : {
		"percent" : 60.0, 
		"string" : "1",
		"value" : 0.5
	},
	ZERO_OPTION : {
		"percent" : 100.0, 
		"string" : "0",
		"value" : 0
	},
}


const comment_damage_type_string = {
	PHYSICAL : "물리", 
	MAGIC : "마법"
}

const comment_type_string = {
	HAT : "모자",
	SHIRT : "상의", 
	PANTS : "하의",
	SHOES : "신발", 
	EARRING : "귀고리",
	RING : "반지", 
	BELT : "벨트", 
	CLOAK : "망토",
	ONE_HAND : "한손 검",
	TWO_HAND : "두손 검", 
	BOW : "활", 
	CROSS_BOW : "석궁", 
	WAND : "완드", 
	STAFF : "스태프"
}

const WEAPON_VALUE = {
	ONE_HAND : {
		"value" : 1.4, 
		"speed" : 1.4
	}, 
	TWO_HAND : {
		"value" : 1.8, 
		"speed" : 0.8 
	}, 
	BOW : {
		"value" : 1.0, 
		"speed" : 1.8 
	}, 
	CROSS_BOW : {
		"value" : 1.5, 
		"speed" : 1.2
	},
	WAND : {
		"value" : 1.3, 
		"speed" : 1.5
	}, 
	STAFF : {
		"value" : 1.7, 
		"speed" : 1.2
	}
}

var comment_inventory_type_string = {
	EQUIPMENT : "equipment", 
	CONSUMPTION : "consumption", 
	ETC : "etc"
}

"""
	0 ~ 1000 : 무기 
	0 ~ 100 한손검 
	100 ~ 200 두손검 
	200 ~ 300 활 
	300 ~ 400 석궁 
	400 ~ 500 스태프
	500 ~ 600 완드
	
	1000 ~ 2000 : 방어구  
	1000 ~ 1100 : 모자
	1100 ~ 1200 : 상의 
	1200 ~ 1300 : 하의 
	1300 ~ 1400 : 신발 
	1400 ~ 1500 : 귀고리 
	1500 ~ 1600 : 반지 
	1600 ~ 1700 : 벨트 
	1700 ~ 1800 : 망토 
	
	1800 ~ 2000 : 소비 아이템 
	2000 ~ 3000 : 기타 아이템
"""
# 기본 장비들은 프로토타입을 우선으로 하되 추가 능력치 기능 부여 
var prototype = {
	0 : {
		"info" : {
			"id" : 0, 
			"name" : "녹슨 검", 
			"image" : load("res://Assets/equipment/weapon/one_hand/rusty_sword.png"), 
			"field" : ONE_HAND,
			"type" : PHYSICAL,
			"section" : WEAPON, 
			"inventory_type" : EQUIPMENT,
			"comment" : "여행자의 검이 300년 이상의 긴 세월을 정통으로 겪은 녹이 슨 검이다.",
		}, 
		"state" : {
			"damage" : 5, 
		},
		"price" : {
			"buy" : 1, 
			"sell" : 1
		}
	},
	1 : {
		"info" : {
			"id" : 1, 
			"name" : "부러진 책상다리", 
			"image" : load("res://Assets/equipment/weapon/one_hand/broken_leg.png"), 
			"field" : ONE_HAND,
			"type" : PHYSICAL,
			"section" : WEAPON, 
			"inventory_type" : EQUIPMENT,
			"comment" : "인근 초등학교에서 사용하던 책상의 다리이다. 누군가 의도적으로 부순것이 틀림없다.",
		}, 
		"state" : {
			"damage" : 7, 
		},
		"price" : {
			"buy" : 1, 
			"sell" : 1
		}
	},
	2 : {
		"info" : {
			"id" : 2, 
			"name" : "나뭇가지", 
			"image" : load("res://Assets/equipment/weapon/one_hand/branch.png"), 
			"field" : ONE_HAND,
			"type" : PHYSICAL,
			"section" : WEAPON, 
			"inventory_type" : EQUIPMENT,
			"comment" : "뒹굴거리는 나뭇가지. 금방 부러질것이 안봐도 뻔하다.",
		}, 
		"state" : {
			"damage" : 3, 
			"critical_damage" : 1
		},
		"price" : {
			"buy" : 1, 
			"sell" : 1
		}
	},
	3 : {
		"info" : {
			"id" : 3, 
			"name" : "목검", 
			"image" : load("res://Assets/equipment/weapon/one_hand/branch_sword.png"), 
			"field" : ONE_HAND,
			"type" : PHYSICAL,
			"section" : WEAPON, 
			"inventory_type" : EQUIPMENT,
			"comment" : "초급전사들을 훈련시키기위한 연습용 검이다. 나무로 만들어진터라 내구성이 좋지는 않다.",
		}, 
		"state" : {
			"damage" : 10, 
			"armor_penetration" : 1
		},
		"price" : {
			"buy" : 1, 
			"sell" : 1
		}
	},
	4 : {
		"info" : {
			"id" : 4, 
			"name" : "해동된 갈치", 
			"image" : load("res://Assets/equipment/weapon/one_hand/hairtail.png"), 
			"field" : ONE_HAND,
			"type" : PHYSICAL,
			"section" : WEAPON, 
			"inventory_type" : EQUIPMENT,
			"comment" : "직수입한 내동갈치를 상온에서 보관한 것이다. 구워먹으면 맛있을지도?",
		}, 
		"state" : {
			"damage" : 8, 
			"magic_resistance_penetration" : 5
		},
		"price" : {
			"buy" : 1, 
			"sell" : 1
		}
	},
	5 : {
		"info" : {
			"id" : 5, 
			"name" : "주방 칼", 
			"image" : load("res://Assets/equipment/weapon/one_hand/knife.png"), 
			"field" : ONE_HAND,
			"type" : PHYSICAL,
			"section" : WEAPON, 
			"inventory_type" : EQUIPMENT,
			"comment" : "가정집 주방에서 흔히 쓰이는 식칼이다. 가정용으로는 최고지만 전투용으로는 글쎄...?",
		}, 
		"state" : {
			"damage" : 12, 
			"critical_percent" : 2
		},
		"price" : {
			"buy" : 1, 
			"sell" : 1
		}
	},
	6 : {
		"info" : {
			"id" : 6, 
			"name" : "노트북", 
			"image" : load("res://Assets/equipment/weapon/one_hand/laptop.png"), 
			"field" : ONE_HAND,
			"type" : PHYSICAL,
			"section" : WEAPON, 
			"inventory_type" : EQUIPMENT,
			"comment" : "대학입학 기념으로 선물받은 누군가의 노트북이다.",
		}, 
		"state" : {
			"damage" : 9, 
			"armor_penetration" : 3, 
			"critical_damage" : 3, 
		},
		"price" : {
			"buy" : 1, 
			"sell" : 1
		}
	},
	7 : {
		"info" : {
			"id" : 7, 
			"name" : "제련된 검", 
			"image" : load("res://Assets/equipment/weapon/one_hand/refined_sword.png"), 
			"field" : ONE_HAND,
			"type" : PHYSICAL,
			"section" : WEAPON, 
			"inventory_type" : EQUIPMENT,
			"comment" : "철기로 제련한 검이다. 다른 검에 비해 내구성이 아주 뛰어나다.",
		}, 
		"state" : {
			"damage" : 20, 
		},
		"price" : {
			"buy" : 1, 
			"sell" : 1
		}
	},
	8 : {
		"info" : {
			"id" : 8, 
			"name" : "샤프나이프", 
			"image" : load("res://Assets/equipment/weapon/one_hand/sharp_knife.png"), 
			"field" : ONE_HAND,
			"type" : PHYSICAL,
			"section" : WEAPON, 
			"inventory_type" : EQUIPMENT,
			"comment" : "매우 날카로운 검이다. 칼 끝을 스치기만해도 무엇이든 베어버린다. ",
		}, 
		"state" : {
			"damage" : 25, 
			"armor_penetration" : 5, 
			"critical_percent" : 1, 
			"critical_damage" : 3
		},
		"price" : {
			"buy" : 1, 
			"sell" : 1
		}
	},
	9 : {
		"info" : {
			"id" : 9, 
			"name" : "전사의 검", 
			"image" : load("res://Assets/equipment/weapon/one_hand/warrior_sword.png"), 
			"field" : ONE_HAND,
			"type" : PHYSICAL,
			"section" : WEAPON, 
			"inventory_type" : EQUIPMENT,
			"comment" : "초보전사들이 실제상황일때 사용하는 검이다. 초심자용으로 만들어져 다루기 쉽지만 강력하다.",
		}, 
		"state" : {
			"damage" : 30, 
			"critical_damage" : 5
		},
		"price" : {
			"buy" : 1, 
			"sell" : 1
		}
	},
	10 : {
		"info" : {
			"id" : 10, 
			"name" : "한손 망치", 
			"image" : load("res://Assets/equipment/weapon/one_hand/hamer.png"), 
			"field" : ONE_HAND,
			"type" : PHYSICAL,
			"section" : WEAPON, 
			"inventory_type" : EQUIPMENT,
			"comment" : "못을 박거나 호두를 깰때 쓰는 작은 망치이다. 누군가의 뚝배기를 꺠지는 말자",
		}, 
		"state" : {
			"damage" : 23, 
			"critical_damage" : 3
		},
		"price" : {
			"buy" : 1, 
			"sell" : 1
		}
	},
	100 : {
		"info" : {
			"id" : 100, 
			"name" : "돌 검", 
			"image" : load("res://Assets/equipment/weapon/two_hand/stone_sword.png"), 
			"field" : TWO_HAND, 
			"type" : PHYSICAL,
			"section" : WEAPON,
			"inventory_type" : EQUIPMENT,
			"comment" : "돌로된 둔기다. 석쇠구이 불판으로 쓰인다."
		}, 
		"state" : {
			"damage" : 4
		},
		"price" : {
			"buy" : 1, 
			"sell" : 1
		}
	},
	101 : {
		"info" : {
			"id" : 101, 
			"name" : "헤머", 
			"image" : load("res://Assets/equipment/weapon/two_hand/harmer.png"), 
			"field" : TWO_HAND, 
			"type" : PHYSICAL,
			"section" : WEAPON,
			"inventory_type" : EQUIPMENT,
			"comment" : "무언가를 깨거나 부술 때 사용하던 헤머다. 조심히 다루지 않으면 다칠 수 있다."
		}, 
		"state" : {
			"damage" : 6, 
			"critical_damage" : 2
		},
		"price" : {
			"buy" : 1, 
			"sell" : 1
		}
	},
	102 : {
		"info" : {
			"id" : 102, 
			"name" : "고블린 창", 
			"image" : load("res://Assets/equipment/weapon/two_hand/goblin_sword.png"), 
			"field" : TWO_HAND, 
			"type" : PHYSICAL,
			"section" : WEAPON,
			"inventory_type" : EQUIPMENT,
			"comment" : "고블린이 쓰던 창이다. 관리소홀로 인하여 내구성이 좋지 않은 편이다. "
		}, 
		"state" : {
			"damage" : 8,
			"armor" : 5, 
			"magic_resistance" : 5
		},
		"price" : {
			"buy" : 1, 
			"sell" : 1
		}
	},
	103 : {
		"info" : {
			"id" : 103, 
			"name" : "골프 채", 
			"image" : load("res://Assets/equipment/weapon/two_hand/golf_sword.png"), 
			"field" : TWO_HAND, 
			"type" : PHYSICAL,
			"section" : WEAPON,
			"inventory_type" : EQUIPMENT,
			"comment" : "사장님 나이스 샷~"
		}, 
		"state" : {
			"damage" : 12, 
			"armor_penetration" : 5, 
			"magic_resistance_penetration" : 5
		},
		"price" : {
			"buy" : 1, 
			"sell" : 1
		}
	},
	104 : {
		"info" : {
			"id" : 104, 
			"name" : "곡괭이", 
			"image" : load("res://Assets/equipment/weapon/two_hand/pick.png"), 
			"field" : TWO_HAND, 
			"type" : PHYSICAL,
			"section" : WEAPON,
			"inventory_type" : EQUIPMENT,
			"comment" : "석탄 캐던 곡괭이가 왜 여기에?"
		}, 
		"state" : {
			"damage" : 15, 
			"critical_damage" : 3, 
			"critical_percent" : 3
		},
		"price" : {
			"buy" : 1, 
			"sell" : 1
		}
	},
	105 : {
		"info" : {
			"id" : 105, 
			"name" : "낫", 
			"image" : load("res://Assets/equipment/weapon/two_hand/sickle.png"), 
			"field" : TWO_HAND, 
			"type" : PHYSICAL,
			"section" : WEAPON,
			"inventory_type" : EQUIPMENT,
			"comment" : "풀베기용 낫이다. 끝이 녹이 슬어 위협적이지 않지만 베이면 아프기 때문에 조심해야한다. "
		}, 
		"state" : {
			"damage" : 18,
			"final_damage" : 3, 
			"armor_penetration" : 3
		},
		"price" : {
			"buy" : 1, 
			"sell" : 1
		}
	},
	106 : {
		"info" : {
			"id" : 106, 
			"name" : "대검", 
			"image" : load("res://Assets/equipment/weapon/two_hand/big_sword.png"), 
			"field" : TWO_HAND, 
			"type" : PHYSICAL,
			"section" : WEAPON,
			"inventory_type" : EQUIPMENT,
			"comment" : "장인이 만든 무거운 양손검이다. 훈련받은 전사들이 모험을 떠날 때 주로 쓰던 검이다. "
		}, 
		"state" : {
			"damage" : 25, 
			"final_damage" : 5, 
			"armor_penetration" : 2
		},
		"price" : {
			"buy" : 1, 
			"sell" : 1
		}
	},
	200 : {
		
	},
	1100 : {
		"info" :{ 
			"id" : 1100, 
			"name" : "허름한 셔츠",
			"image" : load("res://Assets/equipment/armor/shirt/shabby_shirt.png"), 
			"section" : SHIRT, 
			"inventory_type" : EQUIPMENT,
			"comment" : "허르한 셔츠이다. 곧 찢어질듯 하다.",
		},
		"state" : {
			"max_hp" : 10, 
			"armor" : 15
		},
		"price" : {
			"buy" : 500, 
			"sell" : 70
		}
	},
	1400 : {
		"info" :{ 
			"id" : 1400, 
			"name" : "군번 귀고리",
			"image" : load("res://Assets/equipment/armor/earring/dog_tag.png"), 
			"section" : EARRING, 
			"inventory_type" : EQUIPMENT,
			"comment" : "군번줄을 귀고리 형태로 개량한 것이다. 차고 다니면 딸랑딸랑 소리가 난다.",
		},
		"state" : {
			"max_hp" : 10, 
			"armor" : 15,
			"critical_percent" : 7
		},
		"price" : {
			"buy" : 1500, 
			"sell" : 350
		}
	},
	1800 : {
		"info" :{ 
			"id" : 1800, 
			"name" : "HP회복 포션",
			"image" : load("res://Assets/consumption/hp_potion1.png"), 
			"inventory_type" : CONSUMPTION, 
			"comment" : "체력을 회복하는 물약이다. 체력을 50획복하는 효과를 지닌다."
		},
		"state" : {
			"current_hp" : 50
		},
		"price" : {
			"buy" : 250, 
			"sell" : 30
		}
	},
}
