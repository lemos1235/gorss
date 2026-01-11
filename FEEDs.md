### RSSFeed

```swift
public class RSSFeed {

    /// The name of the channel. It's how people refer to your service. If 
    /// you have an HTML website that contains the same information as your 
    /// RSS file, the title of your channel should be the same as the title 
    /// of your website.
    /// 
    /// Example: GoUpstate.com News Headlines
    public var title: String?
    
    /// The URL to the HTML website corresponding to the channel.
    /// 
    /// Example: http://www.goupstate.com/
    public var link: String?
    
    /// Phrase or sentence describing the channel. 
    /// 
    /// Example: The latest news from GoUpstate.com, a Spartanburg Herald-Journal
    /// Web site.
    public var description: String?
    
    /// The language the channel is written in. This allows aggregators to group 
    /// all Italian language sites, for example, on a single page. A list of 
    /// allowable values for this element, as provided by Netscape, is here:
    /// http://cyber.law.harvard.edu/rss/languages.html
    /// 
    /// You may also use values defined by the W3C:
    /// http://www.w3.org/TR/REC-html40/struct/dirlang.html#langcodes
    /// 
    /// Example: en-us
    public var language: String?
    
    /// Copyright notice for content in the channel.
    /// 
    /// Example: Copyright 2002, Spartanburg Herald-Journal
    public var copyright: String?
    
    /// Email address for person responsible for editorial content.
    /// 
    /// Example: geo@herald.com (George Matesky)
    public var managingEditor: String?
    
    /// Email address for person responsible for technical issues relating to 
    /// channel.
    /// 
    /// Example: betty@herald.com (Betty Guernsey)
    public var webMaster: String?
    
    /// The publication date for the content in the channel. For example, the 
    /// New York Times publishes on a daily basis, the publication date flips 
    /// once every 24 hours. That's when the pubDate of the channel changes. 
    /// All date-times in RSS conform to the Date and Time Specification of 
    /// RFC 822, with the exception that the year may be expressed with two 
    /// characters or four characters (four preferred).
    /// 
    /// Example: Sat, 07 Sep 2002 00:00:01 GMT
    public var pubDate: Date?
    
    /// The last time the content of the channel changed.
    /// 
    /// Example: Sat, 07 Sep 2002 09:42:31 GMT
    public var lastBuildDate: Date?
    
    /// Specify one or more categories that the channel belongs to. Follows the 
    /// same rules as the <item>-level category element.
    /// 
    /// Example: Newspapers
    public var categories: [RSSFeedCategory]?
    
    /// A string indicating the program used to generate the channel.
    /// 
    /// Example: MightyInHouse Content System v2.3
    public var generator: String?
    
    /// A URL that points to the documentation for the format used in the RSS 
    /// file. It's probably a pointer to this page. It's for people who might 
    /// stumble across an RSS file on a Web server 25 years from now and wonder 
    /// what it is.
    /// 
    /// Example: http://blogs.law.harvard.edu/tech/rss
    public var docs: String?
    
    /// Allows processes to register with a cloud to be notified of updates to 
    /// the channel, implementing a lightweight publish-subscribe protocol for 
    /// RSS feeds.
    /// 
    /// Example: <cloud domain="rpc.sys.com" port="80" path="/RPC2" registerProcedure="pingMe" protocol="soap"/>
    /// 
    /// <cloud> is an optional sub-element of <channel>.
    /// 
    /// It specifies a web service that supports the rssCloud interface which can
    /// be implemented in HTTP-POST, XML-RPC or SOAP 1.1.
    /// 
    /// Its purpose is to allow processes to register with a cloud to be notified
    /// of updates to the channel, implementing a lightweight publish-subscribe 
    /// protocol for RSS feeds.
    /// 
    /// <cloud domain="rpc.sys.com" port="80" path="/RPC2" registerProcedure="myCloud.rssPleaseNotify" protocol="xml-rpc" />
    /// 
    /// In this example, to request notification on the channel it appears in, 
    /// you would send an XML-RPC message to rpc.sys.com on port 80, with a path 
    /// of /RPC2. The procedure to call is myCloud.rssPleaseNotify.
    /// 
    /// A full explanation of this element and the rssCloud interface is here:
    /// http://cyber.law.harvard.edu/rss/soapMeetsRss.html#rsscloudInterface
    public var cloud: RSSFeedCloud?

    /// The PICS rating for the channel.
    public var rating: String?
    
    /// ttl stands for time to live. It's a number of minutes that indicates how 
    /// long a channel can be cached before refreshing from the source. 
    ///
    /// Example: 60
    /// 
    /// <ttl> is an optional sub-element of <channel>.
    /// 
    /// ttl stands for time to live. It's a number of minutes that indicates how 
    /// long a channel can be cached before refreshing from the source. This makes
    /// it possible for RSS sources to be managed by a file-sharing network such 
    /// as Gnutella.
    public var ttl: Int?
    
    /// Specifies a GIF, JPEG or PNG image that can be displayed with the channel.
    ///
    /// <image> is an optional sub-element of <channel>, which contains three
    /// required and three optional sub-elements.
    /// 
    /// <url> is the URL of a GIF, JPEG or PNG image that represents the channel.
    /// 
    /// <title> describes the image, it's used in the ALT attribute of the HTML
    /// <img> tag when the channel is rendered in HTML.
    /// 
    /// <link> is the URL of the site, when the channel is rendered, the image
    /// is a link to the site. (Note, in practice the image <title> and <link>
    /// should have the same value as the channel's <title> and <link>.
    /// 
    /// Optional elements include <width> and <height>, numbers, indicating the
    /// width and height of the image in pixels. <description> contains text
    /// that is included in the TITLE attribute of the link formed around the
    /// image in the HTML rendering.
    /// 
    /// Maximum value for width is 144, default value is 88.
    /// 
    /// Maximum value for height is 400, default value is 31.
    public var image: RSSFeedImage?
    
    /// Specifies a text input box that can be displayed with the channel.
    /// 
    /// A channel may optionally contain a <textInput> sub-element, which contains
    /// four required sub-elements.
    /// 
    /// <title> -- The label of the Submit button in the text input area.
    /// 
    /// <description> -- Explains the text input area.
    /// 
    /// <name> -- The name of the text object in the text input area.
    /// 
    /// <link> -- The URL of the CGI script that processes text input requests.
    /// 
    /// The purpose of the <textInput> element is something of a mystery. You can
    /// use it to specify a search engine box. Or to allow a reader to provide 
    /// feedback. Most aggregators ignore it.
    public var textInput: RSSFeedTextInput?
    
    /// A hint for aggregators telling them which hours they can skip.
    /// 
    /// An XML element that contains up to 24 <hour> sub-elements whose value is a
    /// number between 0 and 23, representing a time in GMT, when aggregators, if they
    /// support the feature, may not read the channel on hours listed in the skipHours
    /// element.
    /// 
    /// The hour beginning at midnight is hour zero.
    public var skipHours: [RSSFeedSkipHour]?
    
    /// A hint for aggregators telling them which days they can skip.
    /// 
    /// An XML element that contains up to seven <day> sub-elements whose value 
    /// is Monday, Tuesday, Wednesday, Thursday, Friday, Saturday or Sunday. 
    /// Aggregators may not read the channel during days listed in the skipDays 
    /// element.
    public var skipDays: [RSSFeedSkipDay]?
    
    /// A channel may contain any number of <item>s. An item may represent a 
    /// "story" -- much like a story in a newspaper or magazine; if so its 
    /// description is a synopsis of the story, and the link points to the full 
    /// story. An item may also be complete in itself, if so, the description 
    /// contains the text (entity-encoded HTML is allowed; see examples:
    /// http://cyber.law.harvard.edu/rss/encodingDescriptions.html), and
    /// the link and title may be omitted. All elements of an item are optional, 
    /// however at least one of title or description must be present.
    public var items: [RSSFeedItem]?
    
    
    // MARK: - Namespaces
    
    /// The Dublin Core Metadata Element Set is a standard for cross-domain
    /// resource description.
    /// 
    /// See https://tools.ietf.org/html/rfc5013
    public var dublinCore: DublinCoreNamespace?
    
    /// Provides syndication hints to aggregators and others picking up this RDF Site
    /// Summary (RSS) feed regarding how often it is updated. For example, if you
    /// updated your file twice an hour, updatePeriod would be "hourly" and
    /// updateFrequency would be "2". The syndication module borrows from Ian Davis's
    /// Open Content Syndication (OCS) directory format. It supercedes the RSS 0.91
    /// skipDay and skipHour elements.
    /// 
    /// See http://web.resource.org/rss/1.0/modules/syndication/
    public var syndication: SyndicationNamespace?

    /// iTunes Podcasting Tags are de facto standard for podcast syndication.
    /// See https://help.apple.com/itc/podcasts_connect/#/itcb54353390
    public var iTunes: ITunesNamespace?
    
    public init() { }
    
}
```

#### RSSFeedItem

```swift
public class RSSFeedItem {
    
    /// The title of the item.
    /// 
    /// Example: Venice Film Festival Tries to Quit Sinking
    public var title: String?
    
    /// The URL of the item.
    /// 
    /// Example: http://nytimes.com/2004/12/07FEST.html
    public var link: String?
    
    /// The item synopsis.
    /// 
    /// Example: Some of the most heated chatter at the Venice Film Festival this
    /// week was about the way that the arrival of the stars at the Palazzo del 
    /// Cinema was being staged.
    public var description: String?
    
    /// Email address of the author of the item.
    /// 
    /// Example: oprah\@oxygen.net
    /// 
    /// <author> is an optional sub-element of <item>.
    /// 
    /// It's the email address of the author of the item. For newspapers and 
    /// magazines syndicating via RSS, the author is the person who wrote the 
    /// article that the <item> describes. For collaborative weblogs, the author 
    /// of the item might be different from the managing editor or webmaster. 
    /// For a weblog authored by a single individual it would make sense to omit 
    /// the <author> element.
    /// 
    /// <author>lawyer@boyer.net (Lawyer Boyer)</author>
    public var author: String?
    
    /// Includes the item in one or more categories.
    /// 
    /// <category> is an optional sub-element of <item>.
    /// 
    /// It has one optional attribute, domain, a string that identifies a 
    /// categorization taxonomy.
    /// 
    /// The value of the element is a forward-slash-separated string that 
    /// identifies a hierarchic location in the indicated taxonomy. Processors
    /// may establish conventions for the interpretation of categories. 
    /// 
    /// Two examples are provided below:
    /// 
    /// <category>Grateful Dead</category>
    /// <category domain="http://www.fool.com/cusips">MSFT</category>
    /// 
    /// You may include as many category elements as you need to, for different
    /// domains, and to have an item cross-referenced in different parts of the
    /// same domain.
    public var categories: [RSSFeedItemCategory]?
    
    /// URL of a page for comments relating to the item.
    /// 
    /// Example: http://www.myblog.org/cgi-local/mt/mt-comments.cgi?entry_id=290
    /// 
    /// <comments> is an optional sub-element of <item>.
    /// 
    /// If present, it is the url of the comments page for the item.
    /// 
    /// <comments>http://ekzemplo.com/entry/4403/comments</comments>
    /// 
    /// More about comments here:
    /// http://cyber.law.harvard.edu/rss/weblogComments.html
    public var comments: String?
    
    /// Describes a media object that is attached to the item.
    /// 
    /// <enclosure> is an optional sub-element of <item>.
    /// 
    /// It has three required attributes. url says where the enclosure is located,
    /// length says how big it is in bytes, and type says what its type is, a 
    /// standard MIME type.
    /// 
    /// The url must be an http url.
    /// 
    /// <enclosure url="http://www.scripting.com/mp3s/weatherReportSuite.mp3" 
    /// length="12216320" type="audio/mpeg" />
    public var enclosure: RSSFeedItemEnclosure?
    
    /// A string that uniquely identifies the item.
    /// 
    /// Example: http://inessential.com/2002/09/01.php#a2
    /// 
    /// <guid> is an optional sub-element of <item>.
    /// 
    /// guid stands for globally unique identifier. It's a string that uniquely 
    /// identifies the item. When present, an aggregator may choose to use this 
    /// string to determine if an item is new.
    /// 
    /// <guid>http://some.server.com/weblogItem3207</guid>
    /// 
    /// There are no rules for the syntax of a guid. Aggregators must view them 
    /// as a string. It's up to the source of the feed to establish the 
    /// uniqueness of the string.
    /// 
    /// If the guid element has an attribute named "isPermaLink" with a value of 
    /// true, the reader may assume that it is a permalink to the item, that is, 
    /// a url that can be opened in a Web browser, that points to the full item 
    /// described by the <item> element. An example:
    /// 
    /// <guid isPermaLink="true">http://inessential.com/2002/09/01.php#a2</guid>
    /// 
    /// isPermaLink is optional, its default value is true. If its value is false,
    /// the guid may not be assumed to be a url, or a url to anything in 
    /// particular.
    public var guid: RSSFeedItemGUID?
    
    /// Indicates when the item was published.
    /// 
    /// Example: Sun, 19 May 2002 15:21:36 GMT
    /// 
    /// <pubDate> is an optional sub-element of <item>.
    /// 
    /// Its value is a date, indicating when the item was published. If it's a 
    /// date in the future, aggregators may choose to not display the item until 
    /// that date.
    public var pubDate: Date?
    
    /// The RSS channel that the item came from.
    /// 
    /// <source> is an optional sub-element of <item>.
    /// 
    /// Its value is the name of the RSS channel that the item came from, derived
    /// from its <title>. It has one required attribute, url, which links to the
    /// XMLization of the source.
    /// 
    /// <source url="http://www.tomalak.org/links2.xml">Tomalak's Realm</source>
    /// 
    /// The purpose of this element is to propagate credit for links, to 
    /// publicize the sources of news items. It can be used in the Post command
    /// of an aggregator. It should be generated automatically when forwarding
    /// an item from an aggregator to a weblog authoring tool.
    public var source: RSSFeedItemSource?
    
    
    // MARK: - Namespaces
    
    /// The Dublin Core Metadata Element Set is a standard for cross-domain
    /// resource description.
    /// 
    /// See https://tools.ietf.org/html/rfc5013
    public var dublinCore: DublinCoreNamespace?
    
    /// A module for the actual content of websites, in multiple formats.
    /// 
    /// See http://web.resource.org/rss/1.0/modules/content/
    public var content: ContentNamespace?

    /// iTunes Podcasting Tags are de facto standard for podcast syndication. 
    /// see https://help.apple.com/itc/podcasts_connect/#/itcb54353390
    public var iTunes: ITunesNamespace?
    
    /// Media RSS is a new RSS module that supplements the <enclosure>
    /// capabilities of RSS 2.0.
    public var media: MediaNamespace?
    
    public init() { }
    
}
```

### AtomFeed

```swift
open class AtomFeed {
    
    /// The "atom:title" element is a Text construct that conveys a human-
    /// readable title for an entry or feed.
    public var title: String?
    
    /// The "atom:subtitle" element is a Text construct that conveys a human-
    /// readable description or subtitle for a feed.
    public var subtitle: AtomFeedSubtitle?
    
    /// The "atom:link" element defines a reference from an entry or feed to
    /// a Web resource.  This specification assigns no meaning to the content
    /// (if any) of this element.
    public var links: [AtomFeedLink]?

    /// The "atom:updated" element is a Date construct indicating the most
    /// recent instant in time when an entry or feed was modified in a way
    /// the publisher considers significant.  Therefore, not all
    /// modifications necessarily result in a changed atom:updated value.
    public var updated: Date?
    
    /// The "atom:category" element conveys information about a category
    /// associated with an entry or feed.  This specification assigns no
    /// meaning to the content (if any) of this element.
    public var categories: [AtomFeedCategory]?
    
    /// The "atom:author" element is a Person construct that indicates the
    /// author of the entry or feed.
    /// 
    /// If an atom:entry element does not contain atom:author elements, then
    /// the atom:author elements of the contained atom:source element are
    /// considered to apply.  In an Atom Feed Document, the atom:author
    /// elements of the containing atom:feed element are considered to apply
    /// to the entry if there are no atom:author elements in the locations
    /// described above.
    public var authors: [AtomFeedAuthor]?
    
    /// The "atom:contributor" element is a Person construct that indicates a
    /// person or other entity who contributed to the entry or feed.
    public var contributors: [AtomFeedContributor]?
    
    /// The "atom:id" element conveys a permanent, universally unique
    /// identifier for an entry or feed.
    /// 
    /// Its content MUST be an IRI, as defined by [RFC3987].  Note that the
    /// definition of "IRI" excludes relative references.  Though the IRI
    /// might use a dereferencable scheme, Atom Processors MUST NOT assume it
    /// can be dereferenced.
    /// 
    /// When an Atom Document is relocated, migrated, syndicated,
    /// republished, exported, or imported, the content of its atom:id
    /// element MUST NOT change.  Put another way, an atom:id element
    /// pertains to all instantiations of a particular Atom entry or feed;
    /// revisions retain the same content in their atom:id elements.  It is
    /// suggested that the atom:id element be stored along with the
    /// associated resource.
    /// 
    /// The content of an atom:id element MUST be created in a way that
    /// assures uniqueness.
    /// 
    /// Because of the risk of confusion between IRIs that would be
    /// equivalent if they were mapped to URIs and dereferenced, the
    /// following normalization strategy SHOULD be applied when generating
    /// atom:id elements:
    /// 
    /// -  Provide the scheme in lowercase characters.
    /// -  Provide the host, if any, in lowercase characters.
    /// -  Only perform percent-encoding where it is essential.
    /// -  Use uppercase A through F characters when percent-encoding.
    /// -  Prevent dot-segments from appearing in paths.
    /// -  For schemes that define a default authority, use an empty
    /// authority if the default is desired.
    /// -  For schemes that define an empty path to be equivalent to a path
    /// of "/", use "/".
    /// -  For schemes that define a port, use an empty port if the default
    /// is desired.
    /// -  Preserve empty fragment identifiers and queries.
    /// -  Ensure that all components of the IRI are appropriately character
    /// normalized, e.g., by using NFC or NFKC.
    public var id: String?
    
    /// The "atom:generator" element's content identifies the agent used to
    /// generate a feed, for debugging and other purposes.
    /// 
    /// The content of this element, when present, MUST be a string that is a
    /// human-readable name for the generating agent.  Entities such as
    /// "&amp;" and "&lt;" represent their corresponding characters ("&" and
    /// "<" respectively), not markup.
    /// 
    /// The atom:generator element MAY have a "uri" attribute whose value
    /// MUST be an IRI reference [RFC3987].  When dereferenced, the resulting
    /// URI (mapped from an IRI, if necessary) SHOULD produce a
    /// representation that is relevant to that agent.
    /// 
    /// The atom:generator element MAY have a "version" attribute that
    /// indicates the version of the generating agent.
    public var generator: AtomFeedGenerator?
    
    /// The "atom:icon" element's content is an IRI reference [RFC3987] that
    /// identifies an image that provides iconic visual identification for a
    /// feed.
    ///
    /// The image SHOULD have an aspect ratio of one (horizontal) to one
    /// (vertical) and SHOULD be suitable for presentation at a small size.
    public var icon: String?
    
    /// The "atom:logo" element's content is an IRI reference [RFC3987] that
    /// identifies an image that provides visual identification for a feed.
    /// 
    /// The image SHOULD have an aspect ratio of 2 (horizontal) to 1
    /// (vertical).
    public var logo: String?
    
    /// The "atom:rights" element is a Text construct that conveys
    /// information about rights held in and over an entry or feed.
    /// 
    /// The atom:rights element SHOULD NOT be used to convey machine-readable
    /// licensing information.
    /// 
    /// If an atom:entry element does not contain an atom:rights element,
    /// then the atom:rights element of the containing atom:feed element, if
    /// present, is considered to apply to the entry.
    public var rights: String?
    
    /// The "atom:entry" element represents an individual entry, acting as a
    /// container for metadata and data associated with the entry.  This
    /// element can appear as a child of the atom:feed element, or it can
    /// appear as the document (i.e., top-level) element of a stand-alone
    /// Atom Entry Document.
    public var entries: [AtomFeedEntry]?
    
    public init() { }
    
}
```

#### AtomFeedEntry

```swift
public class AtomFeedEntry {
    
    /// The "atom:title" element is a Text construct that conveys a human-
    /// readable title for an entry or feed.
    public var title: String?
    
    /// The "atom:summary" element is a Text construct that conveys a short
    /// summary, abstract, or excerpt of an entry.
    /// 
    /// atomSummary = element atom:summary { atomTextConstruct }
    /// 
    /// It is not advisable for the atom:summary element to duplicate
    /// atom:title or atom:content because Atom Processors might assume there
    /// is a useful summary when there is none.
    public var summary: AtomFeedEntrySummary?
    
    /// The "atom:author" element is a Person construct that indicates the
    /// author of the entry or feed.
    /// 
    /// If an atom:entry element does not contain atom:author elements, then
    /// the atom:author elements of the contained atom:source element are
    /// considered to apply.  In an Atom Feed Document, the atom:author
    /// elements of the containing atom:feed element are considered to apply
    /// to the entry if there are no atom:author elements in the locations
    /// described above.
    public var authors: [AtomFeedEntryAuthor]?
    
    /// The "atom:contributor" element is a Person construct that indicates a
    /// person or other entity who contributed to the entry or feed.
    public var contributors: [AtomFeedEntryContributor]?
    
    /// The "atom:link" element defines a reference from an entry or feed to
    /// a Web resource.  This specification assigns no meaning to the content
    /// (if any) of this element.
    public var links: [AtomFeedEntryLink]?
    
    /// The "atom:updated" element is a Date construct indicating the most
    /// recent instant in time when an entry or feed was modified in a way
    /// the publisher considers significant.  Therefore, not all
    /// modifications necessarily result in a changed atom:updated value.
    /// 
    /// Publishers MAY change the value of this element over time.
    public var updated: Date?
    
    /// The "atom:category" element conveys information about a category
    /// associated with an entry or feed.  This specification assigns no
    /// meaning to the content (if any) of this element.
    public var categories: [AtomFeedEntryCategory]?
    
    /// The "atom:id" element conveys a permanent, universally unique
    /// identifier for an entry or feed.
    /// 
    /// Its content MUST be an IRI, as defined by [RFC3987].  Note that the
    /// definition of "IRI" excludes relative references.  Though the IRI
    /// might use a dereferencable scheme, Atom Processors MUST NOT assume it
    /// can be dereferenced.
    /// 
    /// When an Atom Document is relocated, migrated, syndicated,
    /// republished, exported, or imported, the content of its atom:id
    /// element MUST NOT change.  Put another way, an atom:id element
    /// pertains to all instantiations of a particular Atom entry or feed;
    /// revisions retain the same content in their atom:id elements.  It is
    /// suggested that the atom:id element be stored along with the
    /// associated resource.
    /// 
    /// The content of an atom:id element MUST be created in a way that
    /// assures uniqueness.
    /// 
    /// Because of the risk of confusion between IRIs that would be
    /// equivalent if they were mapped to URIs and dereferenced, the
    /// following normalization strategy SHOULD be applied when generating
    /// atom:id elements:
    /// 
    /// -  Provide the scheme in lowercase characters.
    /// -  Provide the host, if any, in lowercase characters.
    /// -  Only perform percent-encoding where it is essential.
    /// -  Use uppercase A through F characters when percent-encoding.
    /// -  Prevent dot-segments from appearing in paths.
    /// -  For schemes that define a default authority, use an empty
    /// authority if the default is desired.
    /// -  For schemes that define an empty path to be equivalent to a path
    /// of "/", use "/".
    /// -  For schemes that define a port, use an empty port if the default
    /// is desired.
    /// -  Preserve empty fragment identifiers and queries.
    /// -  Ensure that all components of the IRI are appropriately character
    /// normalized, e.g., by using NFC or NFKC.
    public var id: String?
    
    /// The "atom:content" element either contains or links to the content of
    /// the entry.  The content of atom:content is Language-Sensitive.
    public var content: AtomFeedEntryContent?
    
    /// The "atom:published" element is a Date construct indicating an
    /// instant in time associated with an event early in the life cycle of
    /// the entry.
    /// 
    /// Typically, atom:published will be associated with the initial
    /// creation or first availability of the resource.
    public var published: Date?
    
    /// If an atom:entry is copied from one feed into another feed, then the
    /// source atom:feed's metadata (all child elements of atom:feed other
    /// than the atom:entry elements) MAY be preserved within the copied
    /// entry by adding an atom:source child element, if it is not already
    /// present in the entry, and including some or all of the source feed's
    /// Metadata elements as the atom:source element's children.  Such
    /// metadata SHOULD be preserved if the source atom:feed contains any of
    /// the child elements atom:author, atom:contributor, atom:rights, or
    /// atom:category and those child elements are not present in the source
    /// atom:entry.
    /// 
    /// The atom:source element is designed to allow the aggregation of
    /// entries from different feeds while retaining information about an
    /// entry's source feed. For this reason, Atom Processors that are
    /// performing such aggregation SHOULD include at least the required
    /// feed-level Metadata elements (atom:id, atom:title, and atom:updated)
    /// in the atom:source element.
    public var source: AtomFeedEntrySource?
    
    /// The "atom:rights" element is a Text construct that conveys
    /// information about rights held in and over an entry or feed.
    /// 
    /// The atom:rights element SHOULD NOT be used to convey machine-readable
    /// licensing information.
    /// 
    /// If an atom:entry element does not contain an atom:rights element,
    /// then the atom:rights element of the containing atom:feed element, if
    /// present, is considered to apply to the entry.
    public var rights: String?
    
    /// Media RSS is a new RSS module that supplements the <enclosure>
    /// capabilities of RSS 2.0.
    public var media: MediaNamespace?
    
    public init() { }
    
}
```

### JSONFeed

```swift
public struct JSONFeed {
    
    /// (required, string) is the URL of the version of the format the feed
    /// uses. This should appear at the very top, though we recognize that not all
    /// JSON generators allow for ordering.
    public var version: String?
    
    /// (required, string) is the name of the feed, which will often correspond to
    /// the name of the website (blog, for instance), though not necessarily.
    public var title: String?
    
    /// (optional but strongly recommended, string) is the URL of the resource that
    /// the feed describes. This resource may or may not actually be a "home" page,
    /// but it should be an HTML page. If a feed is published on the public web, 
    /// this should be considered as required. But it may not make sense in the 
    /// case of a file created on a desktop computer, when that file is not shared 
    /// or is shared only privately.
    public var homePageURL: String?
    
    /// (optional but strongly recommended, string) is the URL of the feed, and 
    /// serves as the unique identifier for the feed. As with home_page_url, this 
    /// should be considered required for feeds on the public web.
    public var feedUrl: String?
     
    /// (optional, string) provides more detail, beyond the title, on what the feed
    /// is about. A feed reader may display this text.
    public var description: String?

    /// (optional, string) is a description of the purpose of the feed. This is for 
    /// the use of people looking at the raw JSON, and should be ignored by feed 
    /// readers.
    public var userComment: String?
    
    /// (optional, string) is the URL of a feed that provides the next n items, 
    /// where n is determined by the publisher. This allows for pagination, but 
    /// with the expectation that reader software is not required to use it and 
    /// probably won't use it very often. next_url must not be the same as 
    /// feed_url, and it must not be the same as a previous next_url (to avoid 
    /// infinite loops).
    public var nextUrl: String?
    
    /// (optional, string) is the URL of an image for the feed suitable to be used
    /// in a timeline, much the way an avatar might be used. It should be square
    /// and relatively large - such as 512 x 512 - so that it can be scaled-down
    /// and so that it can look good on retina displays. It should use transparency
    /// where appropriate, since it may be rendered on a non-white background.
    public var icon: String?
    
    /// (optional, string) is the URL of an image for the feed suitable to be used
    /// in a source list. It should be square and relatively small, but not smaller
    /// than 64 x 64 (so that it can look good on retina displays). As with icon, 
    /// this image should use transparency where appropriate, since it may be 
    /// rendered on a non-white background.
    public var favicon: String?
    
    /// (optional, object) specifies the feed author. The author object has 
    /// several members. These are all optional - but if you provide an author 
    /// object, then at least one is required.
    public var author: JSONFeedAuthor?
    
    /// (optional, boolean) says whether or not the feed is finished - that is, 
    /// whether or not it will ever update again. A feed for a temporary event, 
    /// such as an instance of the Olympics, could expire. If the value is true, 
    /// then it's expired. Any other value, or the absence of expired, means the 
    /// feed may continue to update.
    public var expired: Bool?
    
    /// (very optional, array of objects) describes endpoints that can be used to 
    /// subscribe to real-time notifications from the publisher of this feed. Each 
    /// object has a type and url, both of which are required.
    public var hubs: [JSONFeedHub]?
    
    /// The JSONFeed items.
    public var items: [JSONFeedItem]?
    
}
```

#### JSONFeedItem

```swift
public struct JSONFeedItem {
    
    /// (required, string) is unique for that item for that feed over time. If an 
    /// item is ever updated, the id should be unchanged. New items should never 
    /// use a previously-used id. If an id is presented as a number or other type, 
    /// a JSON Feed reader must coerce it to a string. Ideally, the id is the full
    /// URL of the resource described by the item, since URLs make great unique 
    /// identifiers.
    public var id: String?
     
    /// (optional, string) is the URL of the resource described by the item. It's 
    /// the permalink. This may be the same as the id - but should be present 
    /// regardless.
    public var url: String?

    /// (very optional, string) is the URL of a page elsewhere. This is especially
    /// useful for linkblogs. If url links to where you're talking about a thing,
    /// then external_url links to the thing you're talking about.
    public var externalUrl: String?

    /// (optional, string) is plain text. Microblog items in particular may omit 
    /// titles.
    public var title: String?

    /// content_html and content_text are each optional strings - but one or both 
    /// must be present. This is the HTML or plain text of the item. Important: 
    /// the only place HTML is allowed in this format is in content_html. A 
    /// Twitter-like service might use content_text, while a blog might use 
    /// content_html. Use whichever makes sense for your resource. (It doesn't 
    /// even have to be the same for each item in a feed.)
    public var contentText: String?
    
    /// content_html and content_text are each optional strings - but one or both
    /// must be present. This is the HTML or plain text of the item. Important:
    /// the only place HTML is allowed in this format is in content_html. A
    /// Twitter-like service might use content_text, while a blog might use
    /// content_html. Use whichever makes sense for your resource. (It doesn't
    /// even have to be the same for each item in a feed.)
    public var contentHtml: String?
    
    /// (optional, string) is a plain text sentence or two describing the item. 
    /// This might be presented in a timeline, for instance, where a detail view 
    /// would display all of content_html or content_text.
    public var summary: String?
    
    /// (optional, string) is the URL of the main image for the item. This image
    /// may also appear in the content_html - if so, it's a hint to the feed reader
    /// that this is the main, featured image. Feed readers may use the image as a
    /// preview (probably resized as a thumbnail and placed in a timeline).
    public var image: String?
    
    /// (optional, string) is the URL of an image to use as a banner. Some blogging
    /// systems (such as Medium) display a different banner image chosen to go with
    /// each post, but that image wouldn't otherwise appear in the content_html. 
    /// A feed reader with a detail view may choose to show this banner image at 
    /// the top of the detail view, possibly with the title overlaid.
    public var bannerImage: String?

    /// (optional, string) specifies the date in RFC 3339 format. 
    /// (Example: 2010-02-07T14:04:00-05:00.)
    public var datePublished: Date?
    
    /// (optional, string) specifies the modification date in RFC 3339 format.
    public var dateModified: Date?

    /// (optional, object) has the same structure as the top-level author.
    /// If not specified in an item, then the top-level author, if present, is the
    /// author of the item.
    public var author: JSONFeedAuthor?

    /// (optional, array of strings) can have any plain text values you want. Tags 
    /// tend to be just one word, but they may be anything. Note: they are not the 
    /// equivalent of Twitter hashtags. Some blogging systems and other feed 
    /// formats call these categories.
    public var tags: [String]?
    
    /// (optional, array) lists related resources.
    public var attachments: [JSONFeedAttachment]?
    
}
```
