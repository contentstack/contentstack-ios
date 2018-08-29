//
//  ContentstackDefinitions.h
//  Contentstack
//
//  Created by Reefaq on 13/07/15.
//  Copyright (c) 2015 Contentstack. All rights reserved.
//

#ifndef CSIO_Definitions_h
#define CSIO_Definitions_h

    #ifndef NS_ENUM
    #   define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
    #endif

    #ifndef NS_OPTIONS
    #   define NS_OPTIONS(_type, _name) enum _name : _type _name; enum _name : _type
    #endif

    #ifndef CSIO_DEPRECATED
    #  ifdef __deprecated_msg
    #    define CSIO_DEPRECATED(_MSG) __deprecated_msg(_MSG)
    #  else
    #    ifdef __deprecated
    #      define CSIO_DEPRECATED(_MSG) __attribute__((deprecated))
    #    else
    #      define CSIO_DEPRECATED(_MSG)
    #    endif
    #  endif
    #endif

    #if __has_feature(nullability)
    #  define BUILT_NONNULL nonnull
    #  define BUILT_NULLABLE nullable
    #  define BUILT_NONNULL_P _Nonnull
    #  define BUILT_NULLABLE_P _Nullable
    #else
    #  define BUILT_NONNULL
    #  define BUILT_NULLABLE
    #  define BUILT_NONNULL_P
    #  define BUILT_NULLABLE_P
    #endif

    #if __has_feature(assume_nonnull)
    #  ifdef NS_ASSUME_NONNULL_BEGIN
    #    define BUILT_ASSUME_NONNULL_BEGIN NS_ASSUME_NONNULL_BEGIN
    #  else
    #    define BUILT_ASSUME_NONNULL_BEGIN _Pragma("clang assume_nonnull begin")
    #  endif
    #  ifdef NS_ASSUME_NONNULL_END
    #    define BUILT_ASSUME_NONNULL_END NS_ASSUME_NONNULL_END
    #  else
    #    define BUILT_ASSUME_NONNULL_END _Pragma("clang assume_nonnull end")
    #  endif
    #else
    #  define BUILT_ASSUME_NONNULL_BEGIN
    #  define BUILT_ASSUME_NONNULL_END
    #endif

    #if __has_include(<Realm/Realm.h>)
    #  define REALM_INCLUDED
    #endif


    typedef NS_ENUM(NSUInteger, CachePolicy) {
        NETWORK_ONLY = 0,
        CACHE_ONLY,
        CACHE_ELSE_NETWORK,
        NETWORK_ELSE_CACHE,
        CACHE_THEN_NETWORK
    };

    typedef NS_ENUM(NSUInteger, ResponseType){
        CACHE = 0,
        NETWORK
    };

    typedef NS_ENUM(NSUInteger, Language) {
        AFRIKAANS_SOUTH_AFRICA = 0,
        ALBANIAN_ALBANIA,
        ARABIC_ALGERIA,
        ARABIC_BAHRAIN,
        ARABIC_EGYPT,
        ARABIC_IRAQ,
        ARABIC_JORDAN,
        ARABIC_KUWAIT,
        ARABIC_LEBANON,
        ARABIC_LIBYA,
        ARABIC_MOROCCO,
        ARABIC_OMAN,
        ARABIC_QATAR,
        ARABIC_SAUDI_ARABIA,
        ARABIC_SYRIA,
        ARABIC_TUNISIA,
        ARABIC_UNITED_ARAB_EMIRATES,
        ARABIC_YEMEN,
        ARMENIAN_ARMENIA,
        AZERI_CYRILLIC_ARMENIA,
        AZERI_LATIN_AZERBAIJAN,
        BASQUE_BASQUE,
        BELARUSIAN_BELARUS,
        BULGARIAN_BULGARIA,
        CATALAN_CATALAN,
        CHINESE_CHINA,
        CHINESE_HONG_KONG_SAR,
        CHINESE_MACUS_SAR,
        CHINESE_SINGAPORE,
        CHINESE_TAIWAN,
        CHINESE_SIMPLIFIED,
        CHINESE_TRADITIONAL,
        CROATIAN_CROATIA,
        CZECH_CZECH_REPUBLIC,
        DANISH_DENMARK,
        DHIVEHI_MALDIVES,
        DUTCH_BELGIUM,
        DUTCH_NETHERLANDS,
        ENGLISH_AUSTRALIA,
        ENGLISH_BELIZE,
        ENGLISH_CANADA,
        ENGLISH_CARIBBEAN,
        ENGLISH_IRELAND,
        ENGLISH_JAMAICA,
        ENGLISH_NEW_ZEALAND,
        ENGLISH_PHILIPPINES,
        ENGLISH_SOUTH_AFRICA,
        ENGLISH_TRINIDAD_AND_TOBAGO,
        ENGLISH_UNITED_KINGDOM,
        ENGLISH_UNITED_STATES,
        ENGLISH_ZIMBABWE,
        ESTONIAN_ESTONIA,
        FAROESE_FAROE_ISLANDS,
        FARSI_IRAN,
        FINNISH_FINLAND,
        FRENCH_BELGIUM,
        FRENCH_CANADA,
        FRENCH_FRANCE,
        FRENCH_LUXEMBOURG,
        FRENCH_MONACO,
        FRENCH_SWITZERLAND,
        GALICIAN_GALICIAN,
        GEORGIAN_GEORGIA,
        GERMEN_AUSTRIA,
        GERMEN_GERMANY,
        GERMEN_LIENCHTENSTEIN,
        GERMEN_LUXEMBOURG,
        GERMEN_SWITZERLAND,
        GREEK_GREECE,
        GUJARATI_INDIA,
        HEBREW_ISRAEL,
        HINDI_INDIA,
        HUNGARIAN_HUNGARY,
        ICELANDIC_ICELAND,
        INDONESIAN_INDONESIA,
        ITALIAN_ITALY,
        ITALIAN_SWITZERLAND,
        JAPANESE_JAPAN,
        KANNADA_INDIA,
        KAZAKH_KAZAKHSTAN,
        KONKANI_INDIA,
        KOREAN_KOREA,
        KYRGYZ_KAZAKHSTAN,
        LATVIAN_LATVIA,
        LITHUANIAN_LITHUANIA,
        MACEDONIAN_FYROM,
        MALAY_BRUNEI,
        MALAY_MALAYSIA,
        MARATHI_INDIA,
        MONGOLIAN_MONGOLIA,
        NORWEGIAN_BOKMAL_NORWAY,
        NORWEGIAN_NYNORSK_NORWAY,
        POLISH_POLAND,
        PORTUGUESE_BRAZIL,
        PORTUGUESE_PORTUGAL,
        PUNJABI_INDIA,
        ROMANIAN_ROMANIA,
        RUSSIAN_RUSSIA,
        SANSKRIT_INDIA,
        SERBIAN_CYRILLIC_SERBIA,
        SERBIAN_LATIN_SERBIA,
        SLOVAK_SLOVAKIA,
        SLOVENIAN_SLOVENIAN,
        SPANISH_ARGENTINA,
        SPANISH_BOLIVIA,
        SPANISH_CHILE,
        SPANISH_COLOMBIA,
        SPANISH_COSTA_RICA,
        SPANISH_DOMINICAN_REPUBLIC,
        SPANISH_ECUADOR,
        SPANISH_ELSALVADOR,
        SPANISH_GUATEMALA,
        SPANISH_HONDURAS,
        SPANISH_MEXICO,
        SPANISH_NICARAGUA,
        SPANISH_PANAMA,
        SPANISH_PARAGUAY,
        SPANISH_PERU,
        SPANISH_PUERTO_RICO,
        SPANISH_SPAIN,
        SPANISH_URUGUAY,
        SPANISH_VENEZUELA,
        SWAHILI_KENYA,
        SWEDISH_FINLAND,
        SWEDISH_SWEDEN,
        SYRIAC_SYRIA,
        TAMIL_INDIA,
        TATAR_RUSSIA,
        TELUGU_INDIA,
        THAI_THAILAND,
        TURKISH_TURKEY,
        UKRAINIAN_UKRAINE,
        URDU_PAKISTAN,
        UZBEK_CYRILLIC_UZBEKISTAN,
        UZBEK_LATIN_UZEBEKISTAN,
        VIETNAMESE_VIETNAM
    };

    typedef NS_ENUM(NSUInteger, PublishType) {
        ASSET_PUBLISHED = 0,
        ENTRY_PUBLISHED,
        ASSET_UNPUBLISHED,
        ENTRY_UNPUBLISHED,
        ASSET_DELETED,
        ENTRY_DELETED,
        CONTENT_TYPE_DELETED
    };

#endif
