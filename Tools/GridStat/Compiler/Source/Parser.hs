{-# OPTIONS_GHC -w #-}
module Main where
import Tokens
import GSST.AST
import GSST.CodeGen

-- parser produced by Happy Version 1.18.9

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24
	= HappyTerminal (Lexeme)
	| HappyErrorToken Int
	| HappyAbsSyn4 t4
	| HappyAbsSyn5 t5
	| HappyAbsSyn6 t6
	| HappyAbsSyn7 t7
	| HappyAbsSyn8 t8
	| HappyAbsSyn9 t9
	| HappyAbsSyn10 t10
	| HappyAbsSyn11 t11
	| HappyAbsSyn12 t12
	| HappyAbsSyn13 t13
	| HappyAbsSyn14 t14
	| HappyAbsSyn15 t15
	| HappyAbsSyn16 t16
	| HappyAbsSyn17 t17
	| HappyAbsSyn18 t18
	| HappyAbsSyn19 t19
	| HappyAbsSyn20 t20
	| HappyAbsSyn21 t21
	| HappyAbsSyn22 t22
	| HappyAbsSyn23 t23
	| HappyAbsSyn24 t24

action_0 (37) = happyShift action_2
action_0 (4) = happyGoto action_3
action_0 _ = happyFail

action_1 (37) = happyShift action_2
action_1 _ = happyFail

action_2 (28) = happyShift action_4
action_2 _ = happyFail

action_3 (52) = happyAccept
action_3 _ = happyFail

action_4 (36) = happyShift action_6
action_4 (5) = happyGoto action_5
action_4 _ = happyFail

action_5 (51) = happyShift action_9
action_5 (6) = happyGoto action_8
action_5 _ = happyFail

action_6 (33) = happyShift action_7
action_6 _ = happyFail

action_7 (34) = happyShift action_13
action_7 _ = happyFail

action_8 (39) = happyShift action_12
action_8 (7) = happyGoto action_11
action_8 _ = happyFail

action_9 (28) = happyShift action_10
action_9 _ = happyFail

action_10 (38) = happyShift action_19
action_10 _ = happyFail

action_11 (42) = happyShift action_18
action_11 (12) = happyGoto action_16
action_11 (14) = happyGoto action_17
action_11 _ = happyFail

action_12 (28) = happyShift action_15
action_12 _ = happyFail

action_13 (25) = happyShift action_14
action_13 _ = happyFail

action_14 _ = happyReduce_2

action_15 (40) = happyShift action_27
action_15 (8) = happyGoto action_26
action_15 _ = happyFail

action_16 (46) = happyShift action_25
action_16 (13) = happyGoto action_23
action_16 (17) = happyGoto action_24
action_16 _ = happyFail

action_17 (42) = happyShift action_18
action_17 (12) = happyGoto action_22
action_17 (14) = happyGoto action_17
action_17 _ = happyReduce_12

action_18 (28) = happyShift action_21
action_18 _ = happyFail

action_19 (33) = happyShift action_20
action_19 _ = happyFail

action_20 (35) = happyShift action_34
action_20 _ = happyFail

action_21 (36) = happyShift action_33
action_21 _ = happyFail

action_22 _ = happyReduce_11

action_23 (29) = happyShift action_32
action_23 _ = happyFail

action_24 (46) = happyShift action_25
action_24 (13) = happyGoto action_31
action_24 (17) = happyGoto action_24
action_24 _ = happyReduce_14

action_25 (28) = happyShift action_30
action_25 _ = happyFail

action_26 (25) = happyShift action_29
action_26 _ = happyFail

action_27 (33) = happyShift action_28
action_27 _ = happyFail

action_28 (26) = happyShift action_40
action_28 _ = happyFail

action_29 (41) = happyShift action_39
action_29 (10) = happyGoto action_38
action_29 _ = happyFail

action_30 (36) = happyShift action_37
action_30 _ = happyFail

action_31 _ = happyReduce_13

action_32 _ = happyReduce_1

action_33 (33) = happyShift action_36
action_33 _ = happyFail

action_34 (25) = happyShift action_35
action_34 _ = happyFail

action_35 (36) = happyShift action_47
action_35 _ = happyFail

action_36 (34) = happyShift action_46
action_36 _ = happyFail

action_37 (33) = happyShift action_45
action_37 _ = happyFail

action_38 (25) = happyShift action_44
action_38 _ = happyFail

action_39 (33) = happyShift action_43
action_39 _ = happyFail

action_40 (34) = happyShift action_42
action_40 (9) = happyGoto action_41
action_40 _ = happyFail

action_41 (27) = happyShift action_54
action_41 _ = happyFail

action_42 (32) = happyShift action_53
action_42 _ = happyReduce_7

action_43 (26) = happyShift action_52
action_43 _ = happyFail

action_44 (29) = happyShift action_51
action_44 _ = happyFail

action_45 (34) = happyShift action_50
action_45 _ = happyFail

action_46 (25) = happyShift action_49
action_46 _ = happyFail

action_47 (33) = happyShift action_48
action_47 _ = happyFail

action_48 (34) = happyShift action_60
action_48 _ = happyFail

action_49 (43) = happyShift action_59
action_49 _ = happyFail

action_50 (25) = happyShift action_58
action_50 _ = happyFail

action_51 _ = happyReduce_4

action_52 (30) = happyShift action_57
action_52 (11) = happyGoto action_56
action_52 _ = happyFail

action_53 (34) = happyShift action_42
action_53 (9) = happyGoto action_55
action_53 _ = happyFail

action_54 _ = happyReduce_5

action_55 _ = happyReduce_6

action_56 (27) = happyShift action_65
action_56 _ = happyFail

action_57 (34) = happyShift action_64
action_57 _ = happyFail

action_58 (43) = happyShift action_63
action_58 _ = happyFail

action_59 (33) = happyShift action_62
action_59 _ = happyFail

action_60 (25) = happyShift action_61
action_60 _ = happyFail

action_61 (29) = happyShift action_69
action_61 _ = happyFail

action_62 (34) = happyShift action_68
action_62 _ = happyFail

action_63 (33) = happyShift action_67
action_63 _ = happyFail

action_64 (32) = happyShift action_66
action_64 _ = happyFail

action_65 _ = happyReduce_8

action_66 (34) = happyShift action_72
action_66 _ = happyFail

action_67 (34) = happyShift action_71
action_67 _ = happyFail

action_68 (25) = happyShift action_70
action_68 _ = happyFail

action_69 _ = happyReduce_3

action_70 (44) = happyShift action_77
action_70 (15) = happyGoto action_75
action_70 (16) = happyGoto action_76
action_70 _ = happyFail

action_71 (25) = happyShift action_74
action_71 _ = happyFail

action_72 (31) = happyShift action_73
action_72 _ = happyFail

action_73 (32) = happyShift action_84
action_73 _ = happyReduce_10

action_74 (47) = happyShift action_83
action_74 (18) = happyGoto action_81
action_74 (19) = happyGoto action_82
action_74 _ = happyFail

action_75 (29) = happyShift action_80
action_75 _ = happyFail

action_76 (44) = happyShift action_77
action_76 (15) = happyGoto action_79
action_76 (16) = happyGoto action_76
action_76 _ = happyReduce_17

action_77 (28) = happyShift action_78
action_77 _ = happyFail

action_78 (36) = happyShift action_89
action_78 _ = happyFail

action_79 _ = happyReduce_16

action_80 _ = happyReduce_15

action_81 (29) = happyShift action_88
action_81 _ = happyFail

action_82 (47) = happyShift action_83
action_82 (18) = happyGoto action_87
action_82 (19) = happyGoto action_82
action_82 _ = happyReduce_21

action_83 (28) = happyShift action_86
action_83 _ = happyFail

action_84 (30) = happyShift action_57
action_84 (11) = happyGoto action_85
action_84 _ = happyFail

action_85 _ = happyReduce_9

action_86 (48) = happyShift action_92
action_86 (20) = happyGoto action_91
action_86 _ = happyFail

action_87 _ = happyReduce_20

action_88 _ = happyReduce_19

action_89 (33) = happyShift action_90
action_89 _ = happyFail

action_90 (34) = happyShift action_96
action_90 _ = happyFail

action_91 (36) = happyShift action_95
action_91 (21) = happyGoto action_94
action_91 _ = happyFail

action_92 (33) = happyShift action_93
action_92 _ = happyFail

action_93 (34) = happyShift action_101
action_93 _ = happyFail

action_94 (45) = happyShift action_100
action_94 (22) = happyGoto action_99
action_94 _ = happyFail

action_95 (33) = happyShift action_98
action_95 _ = happyFail

action_96 (25) = happyShift action_97
action_96 _ = happyFail

action_97 (45) = happyShift action_107
action_97 _ = happyFail

action_98 (34) = happyShift action_106
action_98 _ = happyFail

action_99 (49) = happyShift action_105
action_99 (23) = happyGoto action_104
action_99 _ = happyFail

action_100 (33) = happyShift action_103
action_100 _ = happyFail

action_101 (25) = happyShift action_102
action_101 _ = happyFail

action_102 _ = happyReduce_23

action_103 (35) = happyShift action_113
action_103 _ = happyFail

action_104 (50) = happyShift action_112
action_104 (24) = happyGoto action_111
action_104 _ = happyFail

action_105 (33) = happyShift action_110
action_105 _ = happyFail

action_106 (25) = happyShift action_109
action_106 _ = happyFail

action_107 (33) = happyShift action_108
action_107 _ = happyFail

action_108 (35) = happyShift action_118
action_108 _ = happyFail

action_109 _ = happyReduce_24

action_110 (35) = happyShift action_117
action_110 _ = happyFail

action_111 (29) = happyShift action_116
action_111 _ = happyFail

action_112 (33) = happyShift action_115
action_112 _ = happyFail

action_113 (25) = happyShift action_114
action_113 _ = happyFail

action_114 _ = happyReduce_25

action_115 (35) = happyShift action_121
action_115 _ = happyFail

action_116 _ = happyReduce_22

action_117 (25) = happyShift action_120
action_117 _ = happyFail

action_118 (25) = happyShift action_119
action_118 _ = happyFail

action_119 (29) = happyShift action_123
action_119 _ = happyFail

action_120 _ = happyReduce_26

action_121 (25) = happyShift action_122
action_121 _ = happyFail

action_122 _ = happyReduce_27

action_123 _ = happyReduce_18

happyReduce_1 = happyReduce 8 4 happyReduction_1
happyReduction_1 (_ `HappyStk`
	(HappyAbsSyn13  happy_var_7) `HappyStk`
	(HappyAbsSyn12  happy_var_6) `HappyStk`
	(HappyAbsSyn7  happy_var_5) `HappyStk`
	(HappyAbsSyn6  happy_var_4) `HappyStk`
	(HappyAbsSyn5  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 (codeGen (Broker happy_var_3 happy_var_4 happy_var_5 happy_var_6 happy_var_7)
	) `HappyStk` happyRest

happyReduce_2 = happyReduce 4 5 happyReduction_2
happyReduction_2 (_ `HappyStk`
	(HappyTerminal ((L _ TLabel happy_var_3))) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn5
		 (happy_var_3
	) `HappyStk` happyRest

happyReduce_3 = happyReduce 11 6 happyReduction_3
happyReduction_3 (_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal ((L _ TLabel happy_var_9))) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal ((L _ TNumber happy_var_5))) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (NameServer (read happy_var_5) happy_var_9
	) `HappyStk` happyRest

happyReduce_4 = happyReduce 7 7 happyReduction_4
happyReduction_4 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (DataPlane happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_5 = happyReduce 5 8 happyReduction_5
happyReduction_5 (_ `HappyStk`
	(HappyAbsSyn9  happy_var_4) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 (happy_var_4
	) `HappyStk` happyRest

happyReduce_6 = happySpecReduce_3  9 happyReduction_6
happyReduction_6 (HappyAbsSyn9  happy_var_3)
	_
	(HappyTerminal ((L _ TLabel happy_var_1)))
	 =  HappyAbsSyn9
		 ((ForwardingEngine happy_var_1):happy_var_3
	)
happyReduction_6 _ _ _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_1  9 happyReduction_7
happyReduction_7 (HappyTerminal ((L _ TLabel happy_var_1)))
	 =  HappyAbsSyn9
		 ([(ForwardingEngine happy_var_1)]
	)
happyReduction_7 _  = notHappyAtAll 

happyReduce_8 = happyReduce 5 10 happyReduction_8
happyReduction_8 (_ `HappyStk`
	(HappyAbsSyn11  happy_var_4) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (happy_var_4
	) `HappyStk` happyRest

happyReduce_9 = happyReduce 7 11 happyReduction_9
happyReduction_9 ((HappyAbsSyn11  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal ((L _ TLabel happy_var_4))) `HappyStk`
	_ `HappyStk`
	(HappyTerminal ((L _ TLabel happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 ((Link happy_var_2 happy_var_4):happy_var_7
	) `HappyStk` happyRest

happyReduce_10 = happyReduce 5 11 happyReduction_10
happyReduction_10 (_ `HappyStk`
	(HappyTerminal ((L _ TLabel happy_var_4))) `HappyStk`
	_ `HappyStk`
	(HappyTerminal ((L _ TLabel happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 ([(Link happy_var_2 happy_var_4)]
	) `HappyStk` happyRest

happyReduce_11 = happySpecReduce_2  12 happyReduction_11
happyReduction_11 (HappyAbsSyn12  happy_var_2)
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn12
		 (happy_var_1:happy_var_2
	)
happyReduction_11 _ _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_1  12 happyReduction_12
happyReduction_12 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn12
		 ([happy_var_1]
	)
happyReduction_12 _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_2  13 happyReduction_13
happyReduction_13 (HappyAbsSyn13  happy_var_2)
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_1:happy_var_2
	)
happyReduction_13 _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_1  13 happyReduction_14
happyReduction_14 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn13
		 ([happy_var_1]
	)
happyReduction_14 _  = notHappyAtAll 

happyReduce_15 = happyReduce 12 14 happyReduction_15
happyReduction_15 (_ `HappyStk`
	(HappyAbsSyn15  happy_var_11) `HappyStk`
	_ `HappyStk`
	(HappyTerminal ((L _ TLabel happy_var_9))) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal ((L _ TLabel happy_var_5))) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn14
		 (Publisher happy_var_5 happy_var_9 happy_var_11
	) `HappyStk` happyRest

happyReduce_16 = happySpecReduce_2  15 happyReduction_16
happyReduction_16 (HappyAbsSyn15  happy_var_2)
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1:happy_var_2
	)
happyReduction_16 _ _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_1  15 happyReduction_17
happyReduction_17 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn15
		 ([happy_var_1]
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happyReduce 11 16 happyReduction_18
happyReduction_18 (_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal ((L _ TNumber happy_var_9))) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal ((L _ TLabel happy_var_5))) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn16
		 (PubVar happy_var_5 (read happy_var_9)
	) `HappyStk` happyRest

happyReduce_19 = happyReduce 12 17 happyReduction_19
happyReduction_19 (_ `HappyStk`
	(HappyAbsSyn18  happy_var_11) `HappyStk`
	_ `HappyStk`
	(HappyTerminal ((L _ TLabel happy_var_9))) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal ((L _ TLabel happy_var_5))) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 (Subscriber happy_var_5 happy_var_9 happy_var_11
	) `HappyStk` happyRest

happyReduce_20 = happySpecReduce_2  18 happyReduction_20
happyReduction_20 (HappyAbsSyn18  happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn18
		 (happy_var_1:happy_var_2
	)
happyReduction_20 _ _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_1  18 happyReduction_21
happyReduction_21 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn18
		 ([happy_var_1]
	)
happyReduction_21 _  = notHappyAtAll 

happyReduce_22 = happyReduce 8 19 happyReduction_22
happyReduction_22 (_ `HappyStk`
	(HappyAbsSyn24  happy_var_7) `HappyStk`
	(HappyAbsSyn23  happy_var_6) `HappyStk`
	(HappyAbsSyn22  happy_var_5) `HappyStk`
	(HappyAbsSyn21  happy_var_4) `HappyStk`
	(HappyAbsSyn20  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn19
		 (SubVar happy_var_3 happy_var_4 happy_var_5 happy_var_6 happy_var_7
	) `HappyStk` happyRest

happyReduce_23 = happyReduce 4 20 happyReduction_23
happyReduction_23 (_ `HappyStk`
	(HappyTerminal ((L _ TLabel happy_var_3))) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (happy_var_3
	) `HappyStk` happyRest

happyReduce_24 = happyReduce 4 21 happyReduction_24
happyReduction_24 (_ `HappyStk`
	(HappyTerminal ((L _ TLabel happy_var_3))) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn21
		 (happy_var_3
	) `HappyStk` happyRest

happyReduce_25 = happyReduce 4 22 happyReduction_25
happyReduction_25 (_ `HappyStk`
	(HappyTerminal ((L _ TNumber happy_var_3))) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn22
		 (read happy_var_3
	) `HappyStk` happyRest

happyReduce_26 = happyReduce 4 23 happyReduction_26
happyReduction_26 (_ `HappyStk`
	(HappyTerminal ((L _ TNumber happy_var_3))) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn23
		 (read happy_var_3
	) `HappyStk` happyRest

happyReduce_27 = happyReduce 4 24 happyReduction_27
happyReduction_27 (_ `HappyStk`
	(HappyTerminal ((L _ TNumber happy_var_3))) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn24
		 (read happy_var_3
	) `HappyStk` happyRest

happyNewToken action sts stk [] =
	action 52 52 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	(L _ TSemi _) -> cont 25;
	(L _ TOList _) -> cont 26;
	(L _ TCList _) -> cont 27;
	(L _ TOElem _) -> cont 28;
	(L _ TCElem _) -> cont 29;
	(L _ TOLink _) -> cont 30;
	(L _ TCLink _) -> cont 31;
	(L _ TComma _) -> cont 32;
	(L _ TEquals _) -> cont 33;
	(L _ TLabel happy_dollar_dollar) -> cont 34;
	(L _ TNumber happy_dollar_dollar) -> cont 35;
	(L _ TKeyword "Name") -> cont 36;
	(L _ TKeyword "Broker") -> cont 37;
	(L _ TKeyword "Port") -> cont 38;
	(L _ TKeyword "DataPlane") -> cont 39;
	(L _ TKeyword "ForwardingEngines") -> cont 40;
	(L _ TKeyword "Links") -> cont 41;
	(L _ TKeyword "Publisher") -> cont 42;
	(L _ TKeyword "Edge") -> cont 43;
	(L _ TKeyword "PubVar") -> cont 44;
	(L _ TKeyword "Rate") -> cont 45;
	(L _ TKeyword "Subscriber") -> cont 46;
	(L _ TKeyword "SubVar") -> cont 47;
	(L _ TKeyword "PubName") -> cont 48;
	(L _ TKeyword "Redundancy") -> cont 49;
	(L _ TKeyword "Latency") -> cont 50;
	(L _ TKeyword "NameServer") -> cont 51;
	_ -> happyError' (tk:tks)
	}

happyError_ 52 tk tks = happyError' tks
happyError_ _ tk tks = happyError' (tk:tks)

newtype HappyIdentity a = HappyIdentity a
happyIdentity = HappyIdentity
happyRunIdentity (HappyIdentity a) = a

instance Monad HappyIdentity where
    return = HappyIdentity
    (HappyIdentity p) >>= q = q p

happyThen :: () => HappyIdentity a -> (a -> HappyIdentity b) -> HappyIdentity b
happyThen = (>>=)
happyReturn :: () => a -> HappyIdentity a
happyReturn = (return)
happyThen1 m k tks = (>>=) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> HappyIdentity a
happyReturn1 = \a tks -> (return) a
happyError' :: () => [(Lexeme)] -> HappyIdentity a
happyError' = HappyIdentity . parseError

gsst tks = happyRunIdentity happySomeParser where
  happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


showLex :: Lexeme -> String
showLex (L pos t str) = {-(show t) ++ ":" ++-} str ++ " " ++ (showPosn pos)

showLexIO :: Lexeme -> IO ()
showLexIO l = putStrLn $ showLex l

parseError :: [Lexeme] -> a
parseError [] = error "Incomplete Input"
parseError (tk:tks) = error $ (redText "Parse error") ++ " at: " ++ (showLex tk)

data ParseResult a = ParseOk a
					| ParseFail String

type P a = String -> Int -> ParseResult a

thenP :: P a -> (a -> P b) -> P b
m `thenP` k = \s l ->
	case m s l of
		ParseFail s -> ParseFail s
		ParseOk a -> k a s l
		
returnP :: a -> P a
returnP a = \s l -> ParseOk a

{- parser str = runAlex str $ do
  let loop i = do tok@(L _ cl _) <- myScan; 
		  case cl of
			TEof -> return i
			otherwise -> do loop $! (i+1)
  loop 0 -}
	
parser2 str = do
  let loop l = do tok@(L _ cl _) <- myScan; 
		  case cl of
			TEof -> return l
			otherwise -> do loop $! (l++[tok])
  loop []

yprintResult :: (Show b) => Either String b -> IO ()

yprintResult (Left a) = putStrLn a
yprintResult (Right b) = putStrLn $ "Parse OK - " ++ show b ++ " tokens"


main = getContents >>=                         		                -- IO String
  ( \str -> return (parser2 str) >>=     		                  	-- String -> IO Alex [Lexeme]
  ( \ax_lx -> return $! (unAlex ax_lx) AlexState {
											alex_pos = alexStartPos,
											alex_inp = str,
											alex_chr = '\n',
											alex_bytes = [],
											alex_scd = 0 }
								) >>= 								-- Alex [Lexeme] -> IO Either String (AlexState, a)
  ( \ax_et -> case ax_et of										    -- Either String (AlexState, a) -> IO ()
    (Left a) -> putStrLn a
    (Right ((AlexState a b c d e), lx)) -> do { 
			{-sequence $ map showLexIO lx;-} 
			putStr $ "\n" ++ (blueText "Parsing System Specification...\t\t");
			gsst lx;})
  )
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "<built-in>" #-}
{-# LINE 1 "<command-line>" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 

{-# LINE 30 "templates/GenericTemplate.hs" #-}








{-# LINE 51 "templates/GenericTemplate.hs" #-}

{-# LINE 61 "templates/GenericTemplate.hs" #-}

{-# LINE 70 "templates/GenericTemplate.hs" #-}

infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is (1), it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
	happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
	 (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action

{-# LINE 148 "templates/GenericTemplate.hs" #-}

-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Int ->                    -- token number
         Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let (i) = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k - ((1) :: Int)) sts of
	 sts1@(((st1@(HappyState (action))):(_))) ->
        	let r = fn stk in  -- it doesn't hurt to always seq here...
       		happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
        happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))
       where (sts1@(((st1@(HappyState (action))):(_)))) = happyDrop k ((st):(sts))
             drop_stk = happyDropStk k stk

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
       happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))
       where (sts1@(((st1@(HappyState (action))):(_)))) = happyDrop k ((st):(sts))
             drop_stk = happyDropStk k stk





             new_state = action


happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n - ((1) :: Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n - ((1)::Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction

{-# LINE 246 "templates/GenericTemplate.hs" #-}
happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery ((1) is the error token)

-- parse error if we are in recovery and we fail again
happyFail (1) tk old_st _ stk@(x `HappyStk` _) =
     let (i) = (case x of { HappyErrorToken (i) -> i }) in
--	trace "failing" $ 
        happyError_ i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  (1) tk old_st (((HappyState (action))):(sts)) 
						(saved_tok `HappyStk` _ `HappyStk` stk) =
--	trace ("discarding state, depth " ++ show (length stk))  $
	action (1) (1) tk (HappyState (action)) sts ((saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail  i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
	action (1) (1) tk (HappyState (action)) sts ( (HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--	happySeq = happyDoSeq
-- otherwise it emits
-- 	happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.

{-# LINE 312 "templates/GenericTemplate.hs" #-}
{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
