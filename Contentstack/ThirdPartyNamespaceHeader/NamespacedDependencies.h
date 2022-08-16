// Namespaced Header

#ifndef __NS_SYMBOL
// We need to have multiple levels of macros here so that __NAMESPACE_PREFIX_ is
// properly replaced by the time we concatenate the namespace prefix.
#define __NS_REWRITE(ns, symbol) ns ## _ ## symbol
#define __NS_BRIDGE(ns, symbol) __NS_REWRITE(ns, symbol)
#define __NS_SYMBOL(symbol) __NS_BRIDGE(CSIO, symbol)
#endif

#ifndef ISO8601DateFormatter
#define ISO8601DateFormatter __NS_SYMBOL(ISO8601DateFormatter)
#endif

#ifndef MMDocument
#define MMDocument __NS_SYMBOL(MMDocument)
#endif

#ifndef MMElement
#define MMElement __NS_SYMBOL(MMElement)
#endif

#ifndef MMGenerator
#define MMGenerator __NS_SYMBOL(MMGenerator)
#endif

#ifndef MMHTMLParser
#define MMHTMLParser __NS_SYMBOL(MMHTMLParser)
#endif

#ifndef MMMarkdown
#define MMMarkdown __NS_SYMBOL(MMMarkdown)
#endif

#ifndef MMParser
#define MMParser __NS_SYMBOL(MMParser)
#endif

#ifndef MMScanner
#define MMScanner __NS_SYMBOL(MMScanner)
#endif

#ifndef MMSpanParser
#define MMSpanParser __NS_SYMBOL(MMSpanParser)
#endif


// Externs
#ifndef ISO8601DefaultTimeSeparatorCharacter
#define ISO8601DefaultTimeSeparatorCharacter __NS_SYMBOL(ISO8601DefaultTimeSeparatorCharacter)
#endif

#ifndef ThirdPartyExtensionVersionString
#define ThirdPartyExtensionVersionString __NS_SYMBOL(ThirdPartyExtensionVersionString)
#endif

#ifndef ThirdPartyExtensionVersionNumber
#define ThirdPartyExtensionVersionNumber __NS_SYMBOL(ThirdPartyExtensionVersionNumber)
#endif

