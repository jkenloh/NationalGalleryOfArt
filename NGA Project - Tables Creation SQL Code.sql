-- Create table for alternative_identifiers
CREATE TABLE IF NOT EXISTS alternative_identifiers (
    uuid TEXT NOT NULL, 
    idschemelabel TEXT NOT NULL,
    identifier TEXT NOT NULL
);

-- Create table for constituents
CREATE TABLE IF NOT EXISTS constituents (
    constituentID INTEGER NOT NULL PRIMARY KEY,
    ULANID TEXT,
    preferredDisplayName TEXT,
    forwardDisplayName TEXT,
    lastName TEXT,
    displayDate TEXT,
    artistOfNGAObject INTEGER NOT NULL,
    beginYear INTEGER,
    endYear INTEGER,
    visualBrowserTimeSpan TEXT,
    nationality TEXT,
    visualBrowserNationality TEXT,
    constituentType TEXT NOT NULL,
    wikidataid TEXT
);

-- Create table for constituents_altnames
CREATE TABLE IF NOT EXISTS constituents_altnames (
    altnameid INTEGER NOT NULL PRIMARY KEY,
    constituentid INTEGER NOT NULL,
    lastname TEXT,
    displayname TEXT,
    forwarddisplayname TEXT,
    nametype TEXT NOT NULL,
    FOREIGN KEY (constituentid) REFERENCES constituents (constituentID)
);

-- Create table for constituents_text_entries
CREATE TABLE IF NOT EXISTS constituents_text_entries (
    constituentID INTEGER NOT NULL,
    text TEXT NOT NULL,
    textType TEXT NOT NULL,
    year TEXT,
    FOREIGN KEY (constituentID) REFERENCES constituents (constituentID)
);

-- Create table for locations
CREATE TABLE IF NOT EXISTS locations (
    locationID INTEGER NOT NULL PRIMARY KEY,
    site TEXT NOT NULL,
    room TEXT NOT NULL,
    publicAccess INTEGER NOT NULL,
    description TEXT NOT NULL,
    unitPosition TEXT,
    FOREIGN KEY (locationID) REFERENCES locations (locationID)
);

-- Create table for media_items
CREATE TABLE IF NOT EXISTS media_items (
    mediaID INTEGER NOT NULL PRIMARY KEY,
    mediaType TEXT NOT NULL,
    title TEXT,
    description TEXT,
    duration INTEGER,
    language TEXT NOT NULL,
    thumbnailURL TEXT,
    playURL TEXT,
    downloadURL TEXT,
    keywords TEXT,
    tags TEXT,
    imageURL TEXT,
    presentationDate TIMESTAMP WITH TIME ZONE,
    releaseDate TIMESTAMP WITH TIME ZONE,
    lastModified TIMESTAMP WITH TIME ZONE
);

-- Create table for media_relationships
CREATE TABLE IF NOT EXISTS media_relationships (
    mediaID INTEGER NOT NULL,
    relatedID INTEGER NOT NULL,
    relatedEntity TEXT NOT NULL,
    PRIMARY KEY (mediaID, relatedID, relatedEntity),
    FOREIGN KEY (mediaID) REFERENCES media_items (mediaID)
);

-- Create table for object_associations
CREATE TABLE IF NOT EXISTS object_associations (
    parentObjectID INTEGER NOT NULL,
    childObjectID INTEGER NOT NULL,
    relationship TEXT NOT NULL,
    PRIMARY KEY (parentObjectID, childObjectID, relationship),
    FOREIGN KEY (parentObjectID) REFERENCES objects (objectID),
    FOREIGN KEY (childObjectID) REFERENCES objects (objectID)
);

-- Create table for objects_altnums
CREATE TABLE IF NOT EXISTS objects_altnums (
    objectID INTEGER NOT NULL,
    altnumtype TEXT NOT NULL,
    altnum TEXT NOT NULL,
	FOREIGN KEY (objectID) REFERENCES objects(objectID)
);

-- Create table for objects_constituents
CREATE TABLE IF NOT EXISTS objects_constituents (
    objectID INTEGER NOT NULL,
    constituentID INTEGER NOT NULL,
    displayOrder INTEGER NOT NULL,
    roleType TEXT NOT NULL,
    role TEXT NOT NULL,
    prefix TEXT,
    suffix TEXT,
    displayDate TEXT,
    beginYear INTEGER,
    endYear INTEGER,
    country TEXT,
    zipCode TEXT,
	FOREIGN KEY (objectID) REFERENCES objects(objectID),
    FOREIGN KEY (constituentID) REFERENCES constituents(constituentID)
);

-- Create table for objects_dimensions
CREATE TABLE IF NOT EXISTS objects_dimensions (
    objectID INTEGER NOT NULL,
    element TEXT NOT NULL,
    dimensionType TEXT NOT NULL,
    dimension DECIMAL(22,10) NOT NULL,
    unitName TEXT NOT NULL,
	FOREIGN KEY (objectID) REFERENCES objects(objectID)
);

-- Create table for objects_historical_data
CREATE TABLE IF NOT EXISTS objects_historical_data (
    dataType TEXT NOT NULL,
    objectID INTEGER NOT NULL,
    displayOrder INTEGER NOT NULL,
    forwardText TEXT,
    invertedText TEXT,
    remarks TEXT,
    effectiveDate TEXT,
	FOREIGN KEY (objectID) REFERENCES objects(objectID)
);

-- Create table for objects
CREATE TABLE IF NOT EXISTS objects (
    objectID INTEGER NOT NULL PRIMARY KEY,
    accessioned INTEGER NOT NULL,
    accessionNum TEXT,
    locationID INTEGER,
    title TEXT,
    displayDate TEXT,
    beginYear INTEGER,
    endYear INTEGER,
    visualBrowserTimeSpan TEXT,
    medium TEXT,
    dimensions TEXT,
    inscription TEXT,
    markings TEXT,
    attributionInverted TEXT,
    attribution TEXT,
    creditLine TEXT,
    classification TEXT,
    subClassification TEXT,
    visualBrowserClassification TEXT,
    provenanceText TEXT,
    parentID INTEGER,
    isVirtual INTEGER NOT NULL,
    departmentAbbr TEXT NOT NULL,
    portfolio TEXT,
    series TEXT,
    volume TEXT,
    watermarks TEXT,
    lastDetectedModification TIMESTAMP WITH TIME ZONE,
    wikidataid TEXT,
    customPrintURL TEXT
);

-- Create table for objects_terms
CREATE TABLE IF NOT EXISTS objects_terms (
    termID INTEGER NOT NULL,
    objectID INTEGER NOT NULL,
    termType TEXT NOT NULL,
    term TEXT,
    visualBrowserTheme TEXT,
    visualBrowserStyle TEXT,
	FOREIGN KEY (objectID) REFERENCES objects(objectID)
);

-- Create table for objects_text_entries
CREATE TABLE IF NOT EXISTS objects_text_entries (
    objectID INTEGER NOT NULL,
    text TEXT NOT NULL,
    textType TEXT NOT NULL,
    year TEXT,
	FOREIGN KEY (objectID) REFERENCES objects(objectID)
);

-- Create table for preferred_locations
CREATE TABLE IF NOT EXISTS preferred_locations (
    locationKey TEXT NOT NULL, 
    locationType TEXT NOT NULL,
    description TEXT NOT NULL,
    isPublicVenue INTEGER NOT NULL,
    mapImageURL TEXT,
    mapShapeType TEXT,
    mapShapeCoords TEXT,
    partof TEXT
);

-- Create table for preferred_locations_tms_locations
CREATE TABLE IF NOT EXISTS preferred_locations_tms_locations (
    preferredLocationKey TEXT NOT NULL,
    tmsLocationID INTEGER NOT NULL,
    PRIMARY KEY (preferredLocationKey, tmsLocationID),
    FOREIGN KEY (tmsLocationID) REFERENCES locations (locationID)
);

-- Create table for published_images
CREATE TABLE IF NOT EXISTS published_images (
    uuid TEXT NOT NULL PRIMARY KEY,
    iiifURL TEXT,
    iiifThumbURL TEXT,
    viewtype TEXT,
    sequence TEXT,
    width INTEGER,
    height INTEGER,
    maxpixels INTEGER,
    created TIMESTAMP WITH TIME ZONE,
    modified TIMESTAMP WITH TIME ZONE,
    depictstmsobjectid INTEGER,
    assistivetext TEXT
);
