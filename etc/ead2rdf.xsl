<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcmiype="http://purl.org/dc/dcmitype/" xmlns:bibo="http://purl.org/ontology/bibo/" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:bio="http://purl.org/vocab/bio/0.1/" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:wgs84_pos="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:ore="http://www.openarchives.org/ore/terms/" xmlns:lvont="http://lexvo.org/ontology#" xmlns:lode="http://linkedevents.org/ontology/" xmlns:event="http://purl.org/NET/c4dm/event.owl#" xmlns:time="http://www.w3.org/2006/time#" xmlns:timeline="http://purl.org/NET/c4dm/timeline.owl#" xmlns:arch="http://purl.org/archival/vocab/arch#" xmlns:crm="http://erlangen-crm.org/current/"
xmlns:urn="isbn:1-931666-22-9">

<!-- removed 'convert to integer in 5 places. ELM (December 9, 2013) -->

<!--
Created by Pete Johnston, Eduserv for the LOCAH project, 2010-2011

Copyright (c) 2011, Eduserv
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Eduserv nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL EDUSERV BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-->

<xsl:output method="xml" indent="yes"/>

<xsl:param name="root">http://infomotions.com/sandbox/liam/</xsl:param>

<!-- Variables for making URIs -->
<xsl:variable name="rdf">http://www.w3.org/1999/02/22-rdf-syntax-ns#</xsl:variable>
<xsl:variable name="rdfs">http://www.w3.org/2000/01/rdf-schema#</xsl:variable>
<xsl:variable name="owl">http://www.w3.org/2002/07/owl#</xsl:variable>
<xsl:variable name="xsd">http://www.w3.org/2001/XMLSchema#</xsl:variable>
<xsl:variable name="dcterms">http://purl.org/dc/terms/</xsl:variable>
<xsl:variable name="dcmitype">http://purl.org/dc/dcmitype/</xsl:variable>
<xsl:variable name="bibo">http://purl.org/ontology/bibo/</xsl:variable>
<xsl:variable name="foaf">http://xmlns.com/foaf/0.1/</xsl:variable>
<xsl:variable name="bio">http://purl.org/vocab/bio/0.1/</xsl:variable>
<xsl:variable name="skos">http://www.w3.org/2004/02/skos/core#</xsl:variable>
<xsl:variable name="wg84_pos">http://www.w3.org/2003/01/geo/wgs84_pos#</xsl:variable>
<xsl:variable name="ore">http://www.openarchives.org/ore/terms/</xsl:variable>
<xsl:variable name="lvont">http://lexvo.org/ontology#</xsl:variable>
<xsl:variable name="lode">http://linkedevents.org/ontology/</xsl:variable>
<xsl:variable name="event">http://purl.org/NET/c4dm/event.owl#</xsl:variable>
<xsl:variable name="time">http://www.w3.org/2006/time#</xsl:variable>
<xsl:variable name="timeline">http://purl.org/NET/c4dm/timeline.owl#</xsl:variable>
<xsl:variable name="crm">http://erlangen-crm.org/current/</xsl:variable>
<xsl:variable name="ref">http://reference.data.gov.uk/id/</xsl:variable>
<xsl:variable name="def">http://data.archiveshub.ac.uk/def/</xsl:variable>

<!-- For making thing URIs -->
<xsl:variable name="id"><xsl:value-of select="concat($root, 'id/')"/></xsl:variable>

<xsl:variable name="hubpageroot">http://infomotions.com/sandbox/liam/</xsl:variable>

<xsl:variable name="archonhtmlroot">http://www.nationalarchives.gov.uk/archon/searches/locresult_details.asp?LR=</xsl:variable>

<!-- N.B. The following assumes the same institution is the maintenance agency of the EAD doc and the repository providing acccess to the materials! -->

<xsl:variable name="normeadid">
	<xsl:choose>
		<xsl:when test="/ead/eadheader/eadid = /ead/eadheader/eadid/@publicid">
			<xsl:value-of select="normalize-space(/ead/archdesc/did/unitid)"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="normalize-space(/ead/eadheader/eadid)"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="countrycode">
	<xsl:choose>
		<xsl:when test="/ead/eadheader/eadid/@countrycode">
			<xsl:value-of select="upper-case(normalize-space(/ead/eadheader/eadid/@countrycode))"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
				<xsl:when test="/ead/archdesc/did/unitid/@countrycode">
					<xsl:value-of select="upper-case(normalize-space(/ead/archdesc/did/unitid/@countrycode))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="eadid" select="tokenize($normeadid, ' ')"/>
					<xsl:choose>
						<xsl:when test="count($eadid) &gt; 2">
							<xsl:value-of select="upper-case($eadid[1])"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:message>Error: Unable to determine countrycode - using GB</xsl:message>
							<xsl:value-of select="'GB'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="mainagencycode">
	<xsl:choose>
		<xsl:when test="/ead/eadheader/eadid/@mainagencycode">
			<xsl:value-of select="(/ead/eadheader/eadid/@mainagencycode)"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
				<xsl:when test="/ead/archdesc/did/unitid/@repositorycode">
					<xsl:value-of select="(/ead/archdesc/did/unitid/@repositorycode)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="eadid" select="tokenize($normeadid, ' ')"/>
					<xsl:choose>
						<xsl:when test="count($eadid) &gt; 2">
							<xsl:value-of select="($eadid[2])"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:message>Error: Unable to determine mainagencycode/repositorycode - using 99999</xsl:message>
							<xsl:value-of select="'99999'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="repositoryid" select="concat(lower-case($countrycode), $mainagencycode)"/>

<xsl:variable name="slugeadid"><xsl:call-template name="slugify"><xsl:with-param name="text" select="$normeadid"/></xsl:call-template></xsl:variable>
<xsl:variable name="hubeadid"><xsl:call-template name="hubify"><xsl:with-param name="text" select="$normeadid"/></xsl:call-template></xsl:variable>

<xsl:variable name="units">
	<unit singular="archive box" plural="archive boxes" property="archbox"/>
	<unit singular="box" plural="boxes" property="archbox"/>
	<unit singular="linear metre" plural="linear metres" property="metre"/>
	<unit singular="metre" plural="metres" property="metre"/>
	<unit singular="meter" plural="meters" property="metre"/>
	<unit singular="m" plural="m" property="metre"/>
	<unit singular="cubic metre" plural="cubic metres" property="cubicmetre"/>
	<unit singular="cubic meter" plural="cubic meters" property="cubicmetre"/>
	<unit singular="folder" plural="folders" property="folder"/>
	<unit singular="envelope" plural="envelopes" property="envelope"/>
	<unit singular="volume" plural="volumes" property="volume"/>
	<unit singular="file" plural="files" property="file"/>
	<unit singular="item" plural="items" property="item"/>
	<unit singular="page" plural="pages" property="page"/>
	<unit singular="paper" plural="papers" property="paper"/>
</xsl:variable>

<xsl:template match="ead">
	<xsl:element name="rdf:RDF">
		<xsl:apply-templates select="eadheader"/>
		<xsl:apply-templates select="archdesc"/>
	</xsl:element>
</xsl:template>

<xsl:template match="eadheader">

	<xsl:comment>About the finding aid</xsl:comment>

	<xsl:variable name="thing"><xsl:value-of select="concat($id, $slugeadid)"/></xsl:variable>
	<xsl:variable name="label"><xsl:value-of select="normalize-space(filedesc/titlestmt/titleproper)"/></xsl:variable>

	<xsl:element namespace="{$def}" name="FindingAid">
		<xsl:attribute name="rdf:about">
			<xsl:value-of select="$thing"/>
		</xsl:attribute>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($foaf, 'Document')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'Document')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element>
		<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element>
		<xsl:element name="dcterms:title"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element>
		<xsl:element name="dcterms:identifier"><xsl:value-of select="$normeadid"/></xsl:element>
		<xsl:if test="normalize-space(filedesc/notestmt/note)">
			<xsl:element name="dcterms:description"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="normalize-space(filedesc/notestmt/note)"/></xsl:element>
		</xsl:if>

		<xsl:element name="dcterms:conformsTo">
			<xsl:element name="dcterms:Standard">
				<xsl:attribute name="rdf:about">http://dbpedia.org/resource/ISAD%28G%29</xsl:attribute>
				<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute>General International Standard for Archival Description</xsl:element>
				<xsl:element name="dcterms:title"><xsl:attribute name="xml:lang">en</xsl:attribute>General International Standard for Archival Description</xsl:element>
			</xsl:element>				
		</xsl:element>
<!--
		<xsl:element name="dcterms:conformsTo">
			<xsl:element name="dcterms:Standard">
				<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'standard/isadg')" /></xsl:attribute>
				<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute>General International Standard for Archival Description</xsl:element>
				<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang">en</xsl:attribute>General International Standard for Archival Description</xsl:element>
				<xsl:element name="dcterms:title"><xsl:attribute name="xml:lang">en</xsl:attribute>General International Standard for Archival Description</xsl:element>
				<xsl:element name="foaf:homepage">
					<xsl:element name="foaf:Document">
						<xsl:attribute name="rdf:about">http://www.icacds.org.uk/eng/standards.htm/</xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:element>

		</xsl:element>
-->
		<xsl:element name="dcterms:publisher">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($id, 'repository/', $repositoryid)"/></xsl:attribute>
		</xsl:element>
		<xsl:element namespace="{$def}" name="encodedAs">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($id, 'ead/', $slugeadid)"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:seeAlso">
			<xsl:element name="foaf:Document">
				<xsl:attribute name="rdf:about"><xsl:value-of select="concat($hubpageroot, $hubeadid)"/></xsl:attribute>
				<xsl:element name="rdf:type">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'Document')"/></xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:element>

	</xsl:element>

	<xsl:comment>About the repository/finding aid maintenance agency</xsl:comment>

	<xsl:variable name="thing"><xsl:value-of select="concat($id, 'repository/', $repositoryid)"/></xsl:variable>
	<xsl:variable name="label"><xsl:value-of select="normalize-space(../archdesc/did/repository)"/></xsl:variable>

	<xsl:element namespace="{$def}" name="Repository">
		<xsl:attribute name="rdf:about">
			<xsl:value-of select="$thing"/>
		</xsl:attribute>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($foaf, 'Organization')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($foaf, 'Agent')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($dcterms, 'Agent')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element>
<!--		<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element> -->
		<xsl:element name="foaf:name"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element>
		<xsl:element name="dcterms:identifier"><xsl:value-of select="$repositoryid"/></xsl:element>
		<xsl:element namespace="{$def}" name="countryCode"><xsl:value-of select="$countrycode"/></xsl:element>
		<xsl:element namespace="{$def}" name="maintenanceAgencyCode"><xsl:value-of select="$mainagencycode"/></xsl:element>
		<xsl:element namespace="{$def}" name="isPublisherOf">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($id, $slugeadid)"/></xsl:attribute>
		</xsl:element>
		<xsl:element namespace="{$def}" name="administers">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($id, 'place/repository/', $repositoryid)"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:seeAlso">
			<xsl:element name="foaf:Document">
				<xsl:attribute name="rdf:about"><xsl:value-of select="concat($archonhtmlroot, (eadid/@mainagencycode))"/></xsl:attribute>
				<xsl:element name="rdf:type">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'Document')"/></xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:element>

	</xsl:element>

	<xsl:comment>About the repository/place</xsl:comment>

	<xsl:variable name="thing"><xsl:value-of select="concat($id, 'place/repository/', $repositoryid)"/></xsl:variable>
	<xsl:variable name="label"><xsl:value-of select="normalize-space(../archdesc/did/repository)"/></xsl:variable>

	<xsl:element name="wgs84_pos:SpatialThing">
		<xsl:attribute name="rdf:about">
			<xsl:value-of select="$thing"/>
		</xsl:attribute>
		<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element>
<!--		<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element> -->
		<xsl:element name="dcterms:title"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element>
		<xsl:element namespace="{$def}" name="isAdministeredBy">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($id, 'repository/', $repositoryid)"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:seeAlso">
			<xsl:element name="foaf:Document">
				<xsl:attribute name="rdf:about"><xsl:value-of select="concat($archonhtmlroot, (eadid/@mainagencycode))"/></xsl:attribute>
				<xsl:element name="rdf:type">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'Document')"/></xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:element>
		
	</xsl:element>

	<xsl:comment>About the EAD XML form of the finding aid</xsl:comment>

	<xsl:variable name="thing"><xsl:value-of select="concat($id, 'ead/', $slugeadid)"/></xsl:variable>
	<xsl:variable name="label"><xsl:value-of select="normalize-space(filedesc/titlestmt/titleproper)"/></xsl:variable>

	<xsl:element namespace="{$def}" name="EAD">
		<xsl:attribute name="rdf:about">
			<xsl:value-of select="$thing"/>
		</xsl:attribute>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($foaf, 'Document')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'Document')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element>
		<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element>
		<xsl:element name="dcterms:title"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element>
		<xsl:element name="dcterms:identifier"><xsl:value-of select="$normeadid"/></xsl:element>
		<xsl:if test="profiledesc/creation">
			<xsl:element name="dcterms:description"><xsl:value-of select="profiledesc/creation"/></xsl:element>
		</xsl:if>
		<!-- could also pull creator name? -->
		<xsl:if test="profiledesc/creation/date">
			<xsl:element name="dcterms:created">
				<xsl:value-of select="profiledesc/creation/date"/>
			</xsl:element>
		</xsl:if>
		<xsl:element name="dcterms:conformsTo">
			<xsl:element name="dcterms:Standard">
				<xsl:attribute name="rdf:about">http://dbpedia.org/resource/Encoded_Archival_Description</xsl:attribute>
				<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute>Encoded Archival Description</xsl:element>
				<xsl:element name="dcterms:title"><xsl:attribute name="xml:lang">en</xsl:attribute>Encoded Archival Description</xsl:element>
			</xsl:element>
		</xsl:element>
		<xsl:element name="dcterms:conformsTo">
			<xsl:element name="dcterms:Standard">
				<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'standard/ead2002')"/></xsl:attribute>
				<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute>Encoded Archival Description (EAD) Version 2002</xsl:element>
				<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang">en</xsl:attribute>Encoded Archival Description (EAD) Version 2002</xsl:element>
				<xsl:element name="dcterms:title"><xsl:attribute name="xml:lang">en</xsl:attribute>Encoded Archival Description (EAD) Version 2002</xsl:element>
				<xsl:element name="foaf:homepage">
					<xsl:element name="foaf:Document">
						<xsl:attribute name="rdf:about">http://loc.gov/ead/</xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:element>				
		</xsl:element>
		<xsl:element namespace="{$def}" name="encodingOf">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($id, $slugeadid)"/></xsl:attribute>
		</xsl:element>

	</xsl:element>
	
</xsl:template>

<xsl:template match="archdesc">

	<xsl:comment>About the top-level archival resource/unit of description</xsl:comment>

	<xsl:variable name="thing"><xsl:value-of select="concat($id, 'archivalresource/', $slugeadid)"/></xsl:variable>

	<xsl:call-template name="make-uod-desc">
		<xsl:with-param name="thing" select="$thing"/>
		<xsl:with-param name="hubunitid" select="$hubeadid"/>
	</xsl:call-template>

	<xsl:apply-templates select="dsc/c01">
		<xsl:with-param name="parent"><xsl:value-of select="$slugeadid"/></xsl:with-param>
	</xsl:apply-templates>
	
</xsl:template>

<xsl:template match="c01|c02|c02|c03|c04|c05|c06|c07|c08|c09|c10|c11|c12">
<xsl:param name="parent"/>

	<xsl:comment>About the <xsl:value-of select="local-name(.)"/> archival resource/unit of description <xsl:value-of select="position()"/></xsl:comment>

	<!-- Ideally use hubunitid to construct thing, but problem of non-unique unitids so count instead -->
	<xsl:variable name="thing"><xsl:value-of select="concat($id, 'archivalresource/', $parent, '-', position())"/></xsl:variable>
	<xsl:variable name="hubunitid"><xsl:value-of select="concat($hubeadid, '-')"/><xsl:call-template name="hubify"><xsl:with-param name="text" select="did/unitid"/></xsl:call-template></xsl:variable>
	
	<xsl:call-template name="make-uod-desc">
		<xsl:with-param name="thing" select="$thing"/>
		<xsl:with-param name="parent" select="$parent"/>
		<xsl:with-param name="hubunitid" select="$hubunitid"/>
	</xsl:call-template>

	<xsl:apply-templates select="c02|c02|c03|c04|c05|c06|c07|c08|c09|c10|c11|c12">
		<xsl:with-param name="parent"><xsl:value-of select="concat($parent, '-', position())"/></xsl:with-param>
	</xsl:apply-templates>
	
</xsl:template>

<xsl:template name="make-uod-desc">
<xsl:param name="thing"/>
<xsl:param name="parent"/>
<xsl:param name="hubunitid"/>

	<xsl:element namespace="{$def}" name="ArchivalResource">
		
		<xsl:attribute name="rdf:about"><xsl:value-of select="$thing"/></xsl:attribute>

		<xsl:element name="foaf:page">
			<xsl:element namespace="{$def}" name="FindingAid">
				<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, $slugeadid)"/></xsl:attribute>
				<xsl:element name="foaf:topic">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing"/></xsl:attribute>
				</xsl:element>
				<xsl:element name="dcterms:subject">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing"/></xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:element>

		<xsl:element namespace="{$def}" name="accessProvidedBy">
			<xsl:element namespace="{$def}" name="Repository">
				<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'repository/', $repositoryid)"/></xsl:attribute>
				<xsl:element namespace="{$def}" name="providesAccessTo">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing"/></xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:element>

		<xsl:variable name="level">
			<xsl:choose>
				<xsl:when test="@level='otherlevel'">
					<xsl:value-of select="@otherlevel"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@level"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="not($level = '')">
			<xsl:element namespace="{$def}" name="level">
	
				<xsl:comment>About the level of description</xsl:comment>
	
				<xsl:variable name="thing"><xsl:value-of select="concat($id, 'level/', $level)"/></xsl:variable>
				<xsl:variable name="label"><xsl:value-of select="$level"/></xsl:variable>
				
				<xsl:element namespace="{$def}" name="Level">
					<xsl:attribute name="rdf:about"><xsl:value-of select="$thing"/></xsl:attribute>
					<xsl:element name="rdf:type">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($skos, 'Concept')"/></xsl:attribute>
					</xsl:element>
					<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$level"/></xsl:element>
					<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$level"/></xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:if>

		<xsl:apply-templates select="did/unitid"/>
		<xsl:apply-templates select="did/unittitle"/>

		<xsl:apply-templates select="did/unitdate">
			<xsl:with-param name="thing" select="$thing"/>
			<xsl:with-param name="label" select="normalize-space(did/unittitle)"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="did/physdesc/extent">
			<xsl:with-param name="thing" select="$thing"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="did/langmaterial/language"/>
		
		<xsl:apply-templates select="did/dao">
			<xsl:with-param name="thing"><xsl:value-of select="$thing"/></xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="did/daogrp">
			<xsl:with-param name="thing"><xsl:value-of select="$thing"/></xsl:with-param>
		</xsl:apply-templates>

		<xsl:apply-templates select="did/origination">
			<xsl:with-param name="unit"><xsl:value-of select="$thing"/></xsl:with-param>
		</xsl:apply-templates>

		<xsl:apply-templates select="bioghist">
			<xsl:with-param name="unit"><xsl:value-of select="$thing"/></xsl:with-param>
			<xsl:with-param name="label" select="normalize-space(did/unittitle)"/>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="custodhist"/>
		<xsl:apply-templates select="acqinfo"/>
		<xsl:apply-templates select="scopecontent"/>
		<xsl:apply-templates select="appraisal"/>
		<xsl:apply-templates select="accruals"/>
		<xsl:apply-templates select="accessrestrict"/>
		<xsl:apply-templates select="userestrict"/>
		<xsl:apply-templates select="phystech"/>
		<xsl:apply-templates select="otherfindaid"/>
		<xsl:apply-templates select="originalsloc"/>
		<xsl:apply-templates select="altformavail"/>
		<xsl:apply-templates select="relatedmaterial"/>
		<xsl:apply-templates select="bibliography"/>
		<xsl:apply-templates select="note"/>
		<xsl:apply-templates select="processinfo"/>

		<xsl:apply-templates select="controlaccess/subject"/>
		<xsl:apply-templates select="controlaccess/persname"/>
		<xsl:apply-templates select="controlaccess/famname"/>
		<xsl:apply-templates select="controlaccess/corpname"/>
		<xsl:apply-templates select="controlaccess/geogname"/>
		<xsl:apply-templates select="controlaccess/title"/>
		<xsl:apply-templates select="controlaccess/genreform"/>
		<xsl:apply-templates select="controlaccess/function"/>

		<xsl:element name="rdfs:seeAlso">
			<xsl:element name="foaf:Document">
				<xsl:attribute name="rdf:about"><xsl:value-of select="concat($hubpageroot, $hubunitid)"/></xsl:attribute>
				<xsl:element name="rdf:type">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'Document')"/></xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:element>
		
		<xsl:if test="dsc/c01|c02|c02|c03|c04|c05|c06|c07|c08|c09|c10|c11|c12">
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($ore, 'Aggregation')"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($dcmitype, 'Collection')"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'Collection')"/></xsl:attribute>
			</xsl:element>
		</xsl:if>

		<xsl:for-each select="dsc/c01|c02|c02|c03|c04|c05|c06|c07|c08|c09|c10|c11|c12">
			<xsl:element name="dcterms:hasPart">
				<xsl:element namespace="{$def}" name="ArchivalResource">
					<xsl:attribute name="rdf:about"><xsl:value-of select="concat($thing, '-', position())"/></xsl:attribute>
					<xsl:element name="dcterms:isPartOf">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing"/></xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:element name="ore:aggregates">
				<xsl:element namespace="{$def}" name="ArchivalResource">
					<xsl:attribute name="rdf:about"><xsl:value-of select="concat($thing, '-', position())"/></xsl:attribute>
					<xsl:element name="ore:isAggregatedBy">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing"/></xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:for-each>
		<!--
		<xsl:if test="dsc/c01|c02|c02|c03|c04|c05|c06|c07|c08|c09|c10|c11|c12">
			<xsl:element namespace="{$def}" name="members">
				<xsl:attribute name="rdf:parseType" select="'Collection'" />
				<xsl:for-each select="dsc/c01|c02|c02|c03|c04|c05|c06|c07|c08|c09|c10|c11|c12">
					<xsl:element name="rdf:Description">
						<xsl:attribute name="rdf:about"><xsl:value-of select="concat($thing, '-', position())" /></xsl:attribute>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:if>
		-->
		
	</xsl:element>

</xsl:template>


<xsl:template match="did/unitid">
		<xsl:element name="dcterms:identifier"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="did/unittitle">
	<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="normalize-space(.)"/></xsl:element>
	<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="normalize-space(.)"/></xsl:element>
	<xsl:element name="dcterms:title"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<!--
<xsl:template match="did/unitdate">
	<xsl:element namespace="{$def}" name="unitdatestring"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>
-->

<xsl:template match="did/unitdate">
<xsl:param name="thing"/>
<xsl:param name="label"/>

	<xsl:element name="dcterms:date"><xsl:value-of select="normalize-space(.)"/></xsl:element>
	<xsl:element namespace="{$def}" name="dateCreatedAccumulatedString"><xsl:value-of select="normalize-space(.)"/></xsl:element>

	<xsl:variable name="indates">
		<xsl:choose>
			<xsl:when test="@normal and not(normalize-space(@normal) = '')">
				<xsl:value-of select="translate(normalize-space(@normal), '-', '/')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="translate(normalize-space(.), '-', '/')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
<!--
	<xsl:element namespace="{$def}" name="unitdateString"><xsl:value-of select="$indates"/></xsl:element>
-->

	<xsl:call-template name="make-unitdate-event">
		<xsl:with-param name="thing" select="$thing"/>
		<xsl:with-param name="label" select="$label"/>
		<xsl:with-param name="indates" select="$indates"/>
	</xsl:call-template>

</xsl:template>

<xsl:template name="make-unitdate-event">
<xsl:param name="thing"/>
<xsl:param name="label"/>
<xsl:param name="indates"/>


	<xsl:choose>
	<!-- Test for yyyymmdd/yyyymmdd with mm, dd optional -->
	<xsl:when test="matches(translate($indates, ' ', ''), '^[1-9]\d{3}(((0[1-9])|(1[0-2]))((0[1-9])|([1-2]\d)|(3[0-1]))?)?/[1-9]\d{3}(((0[1-9])|(1[0-2]))((0[1-9])|([1-2]\d)|(3[0-1]))?)?$')">	

		<xsl:variable name="dates" select="tokenize(translate($indates, ' ', ''), '/')"/>
		
		<xsl:variable name="startdate" select="$dates[1]"/>
		<xsl:variable name="enddate" select="$dates[2]"/>
		<xsl:element namespace="{$def}" name="dateCreatedAccumulatedStart">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$startdate"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element namespace="{$def}" name="dateCreatedAccumulatedEnd">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$enddate"/>
			</xsl:call-template>
		</xsl:element>

		<xsl:element name="event:produced_in">
			<xsl:call-template name="make-creation-event-period">
				<xsl:with-param name="thing" select="$thing"/>
				<xsl:with-param name="label" select="$label"/>
				<xsl:with-param name="startdate" select="$startdate"/>
				<xsl:with-param name="enddate" select="$enddate"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:when>
	<!-- Test for yyyymmdd with mm, dd optional -->
	<xsl:when test="matches(translate($indates, ' ', ''), '^[1-9]\d{3}(((0[1-9])|(1[0-2]))((0[1-9])|([1-2]\d)|(3[0-1]))?)?$')">	

		<xsl:variable name="date" select="translate($indates, ' ', '')"/>
		<xsl:element namespace="{$def}" name="dateCreatedAccumulated">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$date"/>
			</xsl:call-template>
		</xsl:element>
				
		<xsl:element name="event:produced_in">
			<xsl:call-template name="make-creation-event-date">
				<xsl:with-param name="thing" select="$thing"/>
				<xsl:with-param name="label" select="$label"/>
				<xsl:with-param name="date" select="$date"/>
			</xsl:call-template>
		</xsl:element>
				
	</xsl:when>
	<!-- Test for dd MMM yyyy -->
	<xsl:when test="matches($indates, '^(([1-9])|(0[1-9])|([1-2]\d)|(3[0-1]))\s(Jan|January|Feb|February|Mar|March|Apr|April|Jun|June|Jul|July|Aug|August|Sep|September|Oct|October|Nov|November|Dec|December)\s[1-9]\d{3}$')">

		<xsl:variable name="dateparts" select="tokenize($indates, ' ')"/>
		
		<xsl:variable name="dd" select="$dateparts[1]"/>
		<xsl:variable name="yyyy" select="$dateparts[3]"/>
		
		<xsl:variable name="mm">
			<xsl:variable name="short" select="index-of(('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'), $dateparts[2])"/>
			<xsl:choose>
				<xsl:when test="$short">
					<xsl:value-of select="format-number($short, '00')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="long" select="index-of(('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'), $dateparts[2])"/>
					<xsl:value-of select="format-number($long, '00')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="date" select="concat($yyyy, $mm, $dd)"/>
		<xsl:element namespace="{$def}" name="dateCreatedAccumulated">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$date"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="event:produced_in">
			<xsl:call-template name="make-creation-event-date">
				<xsl:with-param name="thing" select="$thing"/>
				<xsl:with-param name="label" select="$label"/>
				<xsl:with-param name="date" select="$date"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:when>
	<!-- Test for MMM yyyy -->
	<xsl:when test="matches($indates, '^(Jan|January|Feb|February|Mar|March|Apr|April|Jun|June|Jul|July|Aug|August|Sep|September|Oct|October|Nov|November|Dec|December)\s[1-9]\d{3}$')">

		<xsl:variable name="dateparts" select="tokenize($indates, ' ')"/>
		
		<xsl:variable name="yyyy" select="$dateparts[2]"/>

		<xsl:variable name="mm">
			<xsl:variable name="short" select="index-of(('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'), $dateparts[1])"/>
			<xsl:choose>
				<xsl:when test="$short">
					<xsl:value-of select="format-number($short, '00')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="long" select="index-of(('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'), $dateparts[1])"/>
					<xsl:value-of select="format-number($long, '00')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="date" select="concat($yyyy, $mm)"/>
		<xsl:element namespace="{$def}" name="dateCreatedAccumulated">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$date"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="event:produced_in">
			<xsl:call-template name="make-creation-event-date">
				<xsl:with-param name="thing" select="$thing"/>
				<xsl:with-param name="label" select="$label"/>
				<xsl:with-param name="date" select="$date"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:when>
	<xsl:otherwise/>
	</xsl:choose>
</xsl:template>

<xsl:template name="make-creation-event-period">
<xsl:param name="thing"/>
<xsl:param name="label"/>
<xsl:param name="startdate"/>
<xsl:param name="enddate"/>
	
	<xsl:comment>About the Creation (Event)</xsl:comment> 

	<xsl:element namespace="{$def}" name="Creation">
		<xsl:attribute name="rdf:about"><xsl:value-of select="replace($thing, 'archivalresource', 'creation')"/></xsl:attribute>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($lode, 'Event')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($event, 'Event')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="concat('Creation of ', $label)"/></xsl:element>
		<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="concat('Creation of ', $label)"/></xsl:element>
		<xsl:element name="event:product">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="lode:involved">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="event:time">
			<xsl:call-template name="make-interval-as-range">
				<xsl:with-param name="uri" select="replace($thing, 'archivalresource', 'creationtime')"/>
				<xsl:with-param name="label" select="concat('Time of Creation of ', $label)"/>
				<xsl:with-param name="startdate" select="$startdate"/>
				<xsl:with-param name="enddate" select="$enddate"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="lode:atTime">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($thing, 'archivalresource', 'creationtime')"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:element>

</xsl:template>

<xsl:template name="make-creation-event-date">
<xsl:param name="thing"/>
<xsl:param name="label"/>
<xsl:param name="date"/>

	<xsl:comment>About the Creation (Event)</xsl:comment> 

	<xsl:element namespace="{$def}" name="Creation">
		<xsl:attribute name="rdf:about"><xsl:value-of select="replace($thing, 'archivalresource', 'creation')"/></xsl:attribute>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($lode, 'Event')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($event, 'Event')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="concat('Creation of ', $label)"/></xsl:element>
		<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="concat('Creation of ', $label)"/></xsl:element>
		<xsl:element name="event:product">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="lode:involved">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="event:time">
			<xsl:call-template name="make-interval-during-date">
				<xsl:with-param name="uri" select="replace($thing, 'archivalresource', 'creationtime')"/>
				<xsl:with-param name="label" select="concat('Time of Creation of ', $label)"/>
				<xsl:with-param name="date" select="$date"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="lode:atTime">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($thing, 'archivalresource', 'creationtime')"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:element>

</xsl:template>


<xsl:template match="did/physdesc/extent">
<xsl:param name="thing"/>
	<xsl:element namespace="{$def}" name="extent"><xsl:value-of select="normalize-space(.)"/></xsl:element>
	
	<xsl:variable name="extent" select="lower-case(normalize-space(.))"/>

	<xsl:element name="dcterms:extent">
		<xsl:comment>About the Extent</xsl:comment> 
		<xsl:element namespace="{$def}" name="Extent">
			<xsl:attribute name="rdf:about"><xsl:value-of select="replace($thing, 'archivalresource', 'extent')"/></xsl:attribute>
<!--			<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, @property, '/', normalize-space(substring-before($extent, @singular)))"/></xsl:attribute> -->
			<xsl:element name="rdfs:label"><xsl:value-of select="$extent"/></xsl:element>
			<xsl:for-each select="$units/unit">
				<xsl:choose>
					<xsl:when test="ends-with($extent, @singular)">
						<xsl:if test="matches(normalize-space(substring-before($extent, @singular)), '(^\d*\.?\d*[1-9]+\d*$)|(^[1-9]+\d*\.\d*$)')">
							<xsl:element namespace="{$def}" name="{@property}">
								<xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#decimal</xsl:attribute>
								<xsl:value-of select="xsd:decimal(normalize-space(substring-before($extent, @singular)))"/>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="ends-with($extent, @plural)">
						<xsl:if test="matches(normalize-space(substring-before($extent, @plural)), '(^\d*\.?\d*[1-9]+\d*$)|(^[1-9]+\d*\.\d*$)')">
							<xsl:element namespace="{$def}" name="{@property}">
								<xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#decimal</xsl:attribute>
								<xsl:value-of select="xsd:decimal(normalize-space(substring-before($extent, @plural)))"/>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:for-each>

		</xsl:element>
	</xsl:element>
	
</xsl:template>

<xsl:template match="did/langmaterial/language">
	<xsl:element name="dcterms:language">
		<xsl:element name="lvont:Language">
			<xsl:attribute name="rdf:about"><xsl:value-of select="concat('http://lexvo.org/id/iso639-3/', @langcode)"/></xsl:attribute>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="did/dao">
<xsl:param name="thing"/>
	<xsl:element namespace="{$def}" name="isRepresentedBy">
		<xsl:element name="foaf:Document">
			<xsl:attribute name="rdf:about"><xsl:value-of select="normalize-space(@href)"/></xsl:attribute>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'Document')"/></xsl:attribute>
			</xsl:element>
			<xsl:element namespace="{$def}" name="represents">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing"/></xsl:attribute>
			</xsl:element>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="did/daogrp">
<xsl:param name="thing"/>

	<xsl:variable name="group"><xsl:value-of select="concat(replace($thing, '/archivalresource/', '/group/'), '-', position())"/></xsl:variable>

	<xsl:element namespace="{$def}" name="isRepresentedBy">
		<xsl:element name="ore:Aggregation">
			<xsl:attribute name="rdf:about"><xsl:value-of select="$group"/></xsl:attribute>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($dcmitype, 'Collection')"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'Collection')"/></xsl:attribute>
			</xsl:element>
			<xsl:element namespace="{$def}" name="represents">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="$thing"/></xsl:attribute>
			</xsl:element>
			<xsl:for-each select="daoloc">
				<xsl:element name="ore:aggregates">
					<xsl:element name="foaf:Document">
						<xsl:attribute name="rdf:about"><xsl:value-of select="normalize-space(@href)"/></xsl:attribute>
						<xsl:element name="rdf:type">
							<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'Document')"/></xsl:attribute>
						</xsl:element>
						<xsl:element name="ore:isAggregatedBy">
							<xsl:attribute name="rdf:resource"><xsl:value-of select="$group"/></xsl:attribute>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="did/origination">
<xsl:param name="unit"/>

	<xsl:variable name="origination">
		<xsl:value-of select="concat($id, 'agent/', $repositoryid, '/')"/><xsl:call-template name="slugify"><xsl:with-param name="text" select="."/></xsl:call-template>
	</xsl:variable>

	<xsl:element namespace="{$def}" name="origination">
		<xsl:element name="foaf:Agent">	
			<xsl:attribute name="rdf:about"><xsl:value-of select="$origination"/></xsl:attribute>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($dcterms, 'Agent')"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="normalize-space(.)"/></xsl:element>
			<xsl:element name="foaf:name"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="normalize-space(.)"/></xsl:element>
			
			<xsl:for-each select="../../bioghist">
			<!-- <xsl:if test="not($bioghist = '')"> -->
				<xsl:variable name="bioghist">
					<xsl:value-of select="replace($unit, '/archivalresource/', '/bioghist/')"/>
				</xsl:variable>

				<xsl:element name="foaf:page">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="$bioghist"/></xsl:attribute>
				</xsl:element>
			<!-- </xsl:if> -->
			</xsl:for-each>
			<xsl:element namespace="{$def}" name="isOriginationOf">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="$unit"/></xsl:attribute>
			</xsl:element>
			
		</xsl:element>
	</xsl:element>

</xsl:template>

<xsl:template match="bioghist">
<xsl:param name="unit"/>
<xsl:param name="label"/>

	<xsl:variable name="bioghist">
		<xsl:value-of select="replace($unit, '/archivalresource/', '/bioghist/')"/>
	</xsl:variable>

	<xsl:element namespace="{$def}" name="hasBiographicalHistory">
		<xsl:element namespace="{$def}" name="BiographicalHistory">
			<xsl:attribute name="rdf:about"><xsl:value-of select="$bioghist"/></xsl:attribute>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($foaf, 'Document')"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'Document')"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'DocumentPart')"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="concat('Biographical History for: ', $label)"/></xsl:element>
			<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="concat('Biographical History for: ', $label)"/></xsl:element>
			<xsl:element name="dcterms:title"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="concat('Biographical History for: ', $label)"/></xsl:element>
			<!--
			<xsl:element namespace="{$def}" name="body">
				<xsl:attribute name="rdf:parseType">Literal</xsl:attribute>
				<xsl:copy-of select="*"/>
			</xsl:element>
			-->
			<xsl:element namespace="{$def}" name="body">
				<xsl:attribute name="xml:lang">en</xsl:attribute>
				<xsl:value-of select="*"/>
			</xsl:element>
			<xsl:for-each select="../did/origination">
			<!--
			<xsl:if test="not($origination = '')">
			-->
				<xsl:variable name="origination">
					<xsl:value-of select="concat($id, 'agent/', $repositoryid, '/')"/><xsl:call-template name="slugify"><xsl:with-param name="text" select="."/></xsl:call-template>
				</xsl:variable>

				<xsl:element name="foaf:topic">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="$origination"/></xsl:attribute>
				</xsl:element>
				<xsl:element name="dcterms:subject">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="$origination"/></xsl:attribute>
				</xsl:element>
			<!--
			</xsl:if>
			-->
			</xsl:for-each>
			<xsl:element namespace="{$def}" name="isBiographicalHistoryFor">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="$unit"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="dcterms:isPartOf">
				<xsl:element namespace="{$def}" name="FindingAid">
					<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, $slugeadid)"/></xsl:attribute>
					<xsl:element name="dcterms:hasPart">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="$bioghist"/></xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="custodhist">
	<!--
	<xsl:element namespace="{$def}" name="custodialHistory">
		<xsl:attribute name="rdf:parseType">Literal</xsl:attribute>
		<xsl:copy-of select="*"/>
	</xsl:element>
	-->
	<xsl:element namespace="{$def}" name="custodialHistory">
		<xsl:attribute name="xml:lang">en</xsl:attribute>
		<xsl:value-of select="*"/>
	</xsl:element>
</xsl:template>

<xsl:template match="acqinfo">
	<!--
	<xsl:element namespace="{$def}" name="acquisitions">
		<xsl:attribute name="rdf:parseType">Literal</xsl:attribute>
		<xsl:copy-of select="*"/>
	</xsl:element>
	-->
	<xsl:element namespace="{$def}" name="acquisitions">
		<xsl:attribute name="xml:lang">en</xsl:attribute>
		<xsl:value-of select="*"/>
	</xsl:element>
</xsl:template>

<xsl:template match="scopecontent">
	<!--
	<xsl:element namespace="{$def}" name="scopecontent">
		<xsl:attribute name="rdf:parseType">Literal</xsl:attribute>
		<xsl:copy-of select="*"/>
	</xsl:element>
	-->
	<xsl:element namespace="{$def}" name="scopecontent">
		<xsl:attribute name="xml:lang">en</xsl:attribute>
		<xsl:value-of select="*"/>
	</xsl:element>
</xsl:template>

<xsl:template match="appraisal">
	<!--
	<xsl:element namespace="{$def}" name="appraisal">
		<xsl:attribute name="rdf:parseType">Literal</xsl:attribute>
		<xsl:copy-of select="*"/>
	</xsl:element>
	-->
	<xsl:element namespace="{$def}" name="appraisal">
		<xsl:attribute name="xml:lang">en</xsl:attribute>
		<xsl:value-of select="*"/>
	</xsl:element>
</xsl:template>

<xsl:template match="accruals">
	<!--
	<xsl:element namespace="{$def}" name="accruals">
		<xsl:attribute name="rdf:parseType">Literal</xsl:attribute>
		<xsl:copy-of select="*"/>
	</xsl:element>
	-->
	<xsl:element namespace="{$def}" name="accruals">
		<xsl:attribute name="xml:lang">en</xsl:attribute>
		<xsl:value-of select="*"/>
	</xsl:element>
</xsl:template>

<xsl:template match="accessrestrict">
	<!--
	<xsl:element namespace="{$def}" name="accessRestrictions">
		<xsl:attribute name="rdf:parseType">Literal</xsl:attribute>
		<xsl:copy-of select="*"/>
	</xsl:element>
	-->
	<xsl:element namespace="{$def}" name="accessRestrictions">
		<xsl:attribute name="xml:lang">en</xsl:attribute>
		<xsl:value-of select="*"/>
	</xsl:element>
</xsl:template>

<xsl:template match="userestrict">
	<!--
	<xsl:element namespace="{$def}" name="useRestrictions">
		<xsl:attribute name="rdf:parseType">Literal</xsl:attribute>
		<xsl:copy-of select="*"/>
	</xsl:element>
	-->
	<xsl:element namespace="{$def}" name="useRestrictions">
		<xsl:attribute name="xml:lang">en</xsl:attribute>
		<xsl:value-of select="*"/>
	</xsl:element>
</xsl:template>

<xsl:template match="phystech">
	<!--
	<xsl:element namespace="{$def}" name="physicalTechnicalRequirements">
		<xsl:attribute name="rdf:parseType">Literal</xsl:attribute>
		<xsl:copy-of select="*"/>
	</xsl:element>
	-->
	<xsl:element namespace="{$def}" name="physicalTechnicalRequirements">
		<xsl:attribute name="xml:lang">en</xsl:attribute>
		<xsl:value-of select="*"/>
	</xsl:element>
</xsl:template>

<xsl:template match="otherfindaid">
	<!--
	<xsl:element namespace="{$def}" name="otherFindingAids">
		<xsl:attribute name="rdf:parseType">Literal</xsl:attribute>
		<xsl:copy-of select="*"/>
	</xsl:element>
	-->
	<xsl:element namespace="{$def}" name="otherFindingAids">
		<xsl:attribute name="xml:lang">en</xsl:attribute>
		<xsl:value-of select="*"/>
	</xsl:element>
</xsl:template>

<xsl:template match="originalsloc">
	<!--
	<xsl:element namespace="{$def}" name="locationOfOriginals">
		<xsl:attribute name="rdf:parseType">Literal</xsl:attribute>
		<xsl:copy-of select="*"/>
	</xsl:element>
	-->
	<xsl:element namespace="{$def}" name="locationOfOriginals">
		<xsl:attribute name="xml:lang">en</xsl:attribute>
		<xsl:value-of select="*"/>
	</xsl:element>
</xsl:template>

<xsl:template match="altformavail">
	<!--
	<xsl:element namespace="{$def}" name="alternateFormsAvailable">
		<xsl:attribute name="rdf:parseType">Literal</xsl:attribute>
		<xsl:copy-of select="*"/>
	</xsl:element>
	-->
	<xsl:element namespace="{$def}" name="alternateFormsAvailable">
		<xsl:attribute name="xml:lang">en</xsl:attribute>
		<xsl:value-of select="*"/>
	</xsl:element>
</xsl:template>

<xsl:template match="relatedmaterial">
	<!--
	<xsl:element namespace="{$def}" name="relatedMaterial">
		<xsl:attribute name="rdf:parseType">Literal</xsl:attribute>
		<xsl:copy-of select="*"/>
	</xsl:element>
	-->
	<xsl:element namespace="{$def}" name="relatedMaterial">
		<xsl:attribute name="xml:lang">en</xsl:attribute>
		<xsl:value-of select="*"/>
	</xsl:element>
</xsl:template>

<xsl:template match="bibliography">
	<!--
	<xsl:element namespace="{$def}" name="bibliography">
		<xsl:attribute name="rdf:parseType">Literal</xsl:attribute>
		<xsl:copy-of select="*"/>
	</xsl:element>
	-->
	<xsl:element namespace="{$def}" name="bibliography">
		<xsl:attribute name="xml:lang">en</xsl:attribute>
		<xsl:value-of select="*"/>
	</xsl:element>
</xsl:template>

<xsl:template match="note">
	<!--
	<xsl:element namespace="{$def}" name="note">
		<xsl:attribute name="rdf:parseType">Literal</xsl:attribute>
		<xsl:copy-of select="*"/>
	</xsl:element>
	-->
	<xsl:element namespace="{$def}" name="note">
		<xsl:attribute name="xml:lang">en</xsl:attribute>
		<xsl:value-of select="*"/>
	</xsl:element>
</xsl:template>

<xsl:template match="processinfo">
	<!--
	<xsl:element namespace="{$def}" name="processing">
		<xsl:attribute name="rdf:parseType">Literal</xsl:attribute>
		<xsl:copy-of select="*"/>
	</xsl:element>
	-->
	<xsl:element namespace="{$def}" name="processing">
		<xsl:attribute name="xml:lang">en</xsl:attribute>
		<xsl:value-of select="*"/>
	</xsl:element>
</xsl:template>

<xsl:template match="controlaccess/subject">

	<xsl:variable name="slug">
		<xsl:call-template name="slugify">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="emph[@altrender]">
						<xsl:for-each select="emph[@altrender]">
							<xsl:value-of select="normalize-space(.)"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space(.)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="prefix">
		<xsl:choose>
			<xsl:when test="@source">
				<xsl:value-of select="normalize-space(@source)"/>
			</xsl:when>
			<xsl:when test="@rules">
				<xsl:value-of select="normalize-space(@rules)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$repositoryid"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="label">
		<xsl:choose>
			<xsl:when test="emph[@altrender]">
				<xsl:for-each select="emph[@altrender]">
					<xsl:value-of select="normalize-space(.)"/>
					<xsl:if test="not(position() = last())">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space(.)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="concept"><xsl:value-of select="concat($id, 'concept/', $prefix, '/', $slug)"/></xsl:variable>
	
	<xsl:element namespace="{$def}" name="associatedWith">
		<xsl:comment>About the Concept (Subject)</xsl:comment> 
		<xsl:element name="skos:Concept">
			<xsl:attribute name="rdf:about"><xsl:value-of select="$concept"/></xsl:attribute>

			<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element>
<!--			<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element> -->

			<xsl:apply-templates/>

			<xsl:element name="skos:inScheme">
				<xsl:element name="skos:ConceptScheme">
					<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'conceptscheme/', $prefix)"/></xsl:attribute>
					<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$prefix"/></xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="controlaccess/subject/emph[@altrender='a']">
	<xsl:element namespace="{$def}" name="name"><xsl:value-of select="."/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/subject/emph[@altrender='y']">
	<xsl:element namespace="{$def}" name="dates"><xsl:value-of select="."/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/subject/emph[@altrender='z']">
	<xsl:element namespace="{$def}" name="location"><xsl:value-of select="."/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/subject/emph[@altrender='x']">
	<xsl:element namespace="{$def}" name="other"><xsl:value-of select="."/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname">

	<xsl:variable name="slug">
		<xsl:call-template name="slugify">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="emph[@altrender]">
						<xsl:for-each select="emph[@altrender]">
							<xsl:value-of select="normalize-space(.)"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space(.)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="prefix">
		<xsl:choose>
			<xsl:when test="@source">
				<xsl:value-of select="normalize-space(@source)"/>
			</xsl:when>
			<xsl:when test="@rules">
				<xsl:value-of select="normalize-space(@rules)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$repositoryid"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="label">
		<xsl:choose>
			<xsl:when test="emph[@altrender]">
				<xsl:for-each select="emph[@altrender]">
					<xsl:value-of select="normalize-space(.)"/>
					<xsl:if test="not(position() = last())">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space(.)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="concept"><xsl:value-of select="concat($id, 'concept/person/', $prefix, '/', $slug)"/></xsl:variable>

	<xsl:variable name="focus"><xsl:value-of select="concat($id, 'person/', $prefix, '/', $slug)"/></xsl:variable>
	
	<xsl:element namespace="{$def}" name="associatedWith">
		<xsl:comment>About the Concept (Person)</xsl:comment> 
		<xsl:element name="skos:Concept">
			<xsl:attribute name="rdf:about"><xsl:value-of select="$concept"/></xsl:attribute>

			<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element>
<!--			<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element> -->
			
			<xsl:apply-templates mode="concept"/>

			<xsl:element name="skos:inScheme">
				<xsl:element name="skos:ConceptScheme">
					<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'conceptscheme/', $prefix)"/></xsl:attribute>
					<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$prefix"/></xsl:element>
				</xsl:element>
			</xsl:element>

			<xsl:element name="foaf:focus">
				<xsl:comment>About the Person</xsl:comment> 
				<xsl:element name="foaf:Person">	
					<xsl:attribute name="rdf:about"><xsl:value-of select="$focus"/></xsl:attribute>
					<xsl:element name="rdf:type">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($foaf, 'Agent')"/></xsl:attribute>
					</xsl:element>
					<xsl:element name="rdf:type">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($dcterms, 'Agent')"/></xsl:attribute>
					</xsl:element>
					<xsl:element name="rdf:type">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($crm, 'E21_Person')"/></xsl:attribute>
					</xsl:element>
					<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element>
					<xsl:apply-templates mode="person">
						<xsl:with-param name="thing" select="$focus"/>
						<xsl:with-param name="label" select="$label"/>
					</xsl:apply-templates>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='a']" mode="concept">
	<xsl:element namespace="{$def}" name="surname"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='a']" mode="person">
<xsl:param name="thing"/>
<xsl:param name="label"/>
	<xsl:element name="foaf:familyName"><xsl:value-of select="normalize-space(.)"/></xsl:element>
	<xsl:element name="foaf:name">
		<xsl:for-each select="../emph[@altrender='forename']">
			<xsl:value-of select="concat(normalize-space(.), ' ')"/>
		</xsl:for-each>
		<xsl:value-of select="normalize-space(.)"/>
	</xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='surname']" mode="concept">
	<xsl:element namespace="{$def}" name="surname"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='surname']" mode="person">
<xsl:param name="thing"/>
<xsl:param name="label"/>
	<xsl:element name="foaf:familyName"><xsl:value-of select="normalize-space(.)"/></xsl:element>
	<xsl:element name="foaf:name">
		<xsl:for-each select="../emph[@altrender='forename']">
			<xsl:value-of select="concat(normalize-space(.), ' ')"/>
		</xsl:for-each>
		<xsl:value-of select="normalize-space(.)"/>
	</xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='forename']" mode="concept">
	<xsl:element namespace="{$def}" name="forename"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='forename']" mode="person">
<xsl:param name="thing"/>
<xsl:param name="label"/>
	<xsl:element name="foaf:givenName"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='y']" mode="concept">
	<xsl:element namespace="{$def}" name="dates"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='y']" mode="person">
<xsl:param name="thing"/>
<xsl:param name="label"/>

	<xsl:element namespace="{$def}" name="dates"><xsl:value-of select="normalize-space(.)"/></xsl:element>

	<xsl:variable name="indates" select="translate(normalize-space(.), '-.() ', '/')"/>

	<xsl:call-template name="make-life-events">
		<xsl:with-param name="person" select="$thing"/>
		<xsl:with-param name="label" select="$label"/>
		<xsl:with-param name="indates" select="$indates"/>
	</xsl:call-template>

</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='dates']" mode="concept">
	<xsl:element namespace="{$def}" name="dates"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='dates']" mode="person">
<xsl:param name="thing"/>
<xsl:param name="label"/>

	<xsl:element namespace="{$def}" name="dates"><xsl:value-of select="normalize-space(.)"/></xsl:element>

	<xsl:variable name="indates" select="translate(normalize-space(.), '-.() ', '/')"/>

	<xsl:call-template name="make-life-events">
		<xsl:with-param name="person" select="$thing"/>
		<xsl:with-param name="label" select="$label"/>
		<xsl:with-param name="indates" select="$indates"/>
	</xsl:call-template>

</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='title']" mode="concept">
	<xsl:element namespace="{$def}" name="title"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='title']" mode="person">
<xsl:param name="thing"/>
<xsl:param name="label"/>
	<xsl:element namespace="{$def}" name="title"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='epithet']" mode="concept">
	<xsl:element namespace="{$def}" name="epithet"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='epithet']" mode="person">
<xsl:param name="thing"/>
<xsl:param name="label"/>
	<xsl:element namespace="{$def}" name="epithet"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='x']" mode="concept">
	<xsl:element namespace="{$def}" name="other"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/persname/emph[@altrender='x']" mode="person">
<xsl:param name="thing"/>
<xsl:param name="label"/>
	<xsl:element namespace="{$def}" name="other"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/famname">

	<xsl:variable name="slug">
		<xsl:call-template name="slugify">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="emph[@altrender]">
						<xsl:for-each select="emph[@altrender]">
							<xsl:value-of select="normalize-space(.)"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space(.)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="prefix">
		<xsl:choose>
			<xsl:when test="@source">
				<xsl:value-of select="normalize-space(@source)"/>
			</xsl:when>
			<xsl:when test="@rules">
				<xsl:value-of select="normalize-space(@rules)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$repositoryid"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="label">
		<xsl:choose>
			<xsl:when test="emph[@altrender]">
				<xsl:for-each select="emph[@altrender]">
					<xsl:value-of select="normalize-space(.)"/>
					<xsl:if test="not(position() = last())">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space(.)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="concept"><xsl:value-of select="concat($id, 'concept/family/', $prefix, '/', $slug)"/></xsl:variable>

	<xsl:variable name="focus"><xsl:value-of select="concat($id, 'family/', $prefix, '/', $slug)"/></xsl:variable>
	
	<xsl:element namespace="{$def}" name="associatedWith">
		<xsl:comment>About the Concept (Family)</xsl:comment> 
		<xsl:element name="skos:Concept">
			<xsl:attribute name="rdf:about"><xsl:value-of select="$concept"/></xsl:attribute>

			<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element>
<!--			<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element> -->

			<xsl:apply-templates mode="concept"/>

			<xsl:element name="skos:inScheme">
				<xsl:element name="skos:ConceptScheme">
					<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'conceptscheme/', $prefix)"/></xsl:attribute>
					<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$prefix"/></xsl:element>
				</xsl:element>
			</xsl:element>

			<xsl:element name="foaf:focus">
				<xsl:comment>About the Family</xsl:comment> 
				<xsl:element namespace="{$def}" name="Family">	
					<xsl:attribute name="rdf:about"><xsl:value-of select="$focus"/></xsl:attribute>
					<xsl:element name="rdf:type">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($foaf, 'Group')"/></xsl:attribute>
					</xsl:element>
					<xsl:element name="rdf:type">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($foaf, 'Agent')"/></xsl:attribute>
					</xsl:element>
					<xsl:element name="rdf:type">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($dcterms, 'Agent')"/></xsl:attribute>
					</xsl:element>
					<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element>
					<xsl:apply-templates mode="family"/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="controlaccess/famname/emph[@altrender='a']" mode="concept">
	<xsl:element namespace="{$def}" name="name"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/famname/emph[@altrender='a']" mode="family">
	<xsl:element name="rdfs:label"><xsl:value-of select="normalize-space(.)"/></xsl:element>
	<xsl:element name="foaf:name"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/famname/emph[@altrender='y']" mode="concept">
	<xsl:element namespace="{$def}" name="dates"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/famname/emph[@altrender='y']" mode="family">
	<xsl:element namespace="{$def}" name="dates"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/famname/emph[@altrender='z']" mode="concept">
	<xsl:element namespace="{$def}" name="location"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/famname/emph[@altrender='z']" mode="family">
	<xsl:element namespace="{$def}" name="location"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/famname/emph[@altrender='x']" mode="concept">
	<xsl:element namespace="{$def}" name="other"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/famname/emph[@altrender='x']" mode="family">
	<xsl:element namespace="{$def}" name="other"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/corpname">

	<xsl:variable name="slug">
		<xsl:call-template name="slugify">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="emph[@altrender]">
						<xsl:for-each select="emph[@altrender]">
							<xsl:value-of select="normalize-space(.)"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space(.)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="prefix">
		<xsl:choose>
			<xsl:when test="@source">
				<xsl:value-of select="normalize-space(@source)"/>
			</xsl:when>
			<xsl:when test="@rules">
				<xsl:value-of select="normalize-space(@rules)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$repositoryid"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="label">
		<xsl:choose>
			<xsl:when test="emph[@altrender]">
				<xsl:for-each select="emph[@altrender]">
					<xsl:value-of select="normalize-space(.)"/>
					<xsl:if test="not(position() = last())">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space(.)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="concept"><xsl:value-of select="concat($id, 'concept/organisation/', $prefix, '/', $slug)"/></xsl:variable>

	<xsl:variable name="focus"><xsl:value-of select="concat($id, 'organisation/', $prefix, '/', $slug)"/></xsl:variable>
	
	<xsl:element namespace="{$def}" name="associatedWith">
		<xsl:comment>About the Concept (Organisation)</xsl:comment> 
		<xsl:element name="skos:Concept">
			<xsl:attribute name="rdf:about"><xsl:value-of select="$concept"/></xsl:attribute>

			<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element>
<!--			<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element> -->

			<xsl:apply-templates mode="concept"/>

			<xsl:element name="skos:inScheme">
				<xsl:element name="skos:ConceptScheme">
					<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'conceptscheme/', $prefix)"/></xsl:attribute>
					<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$prefix"/></xsl:element>
				</xsl:element>
			</xsl:element>

			<xsl:element name="foaf:focus">
				<xsl:comment>About the Organisation</xsl:comment> 
				<xsl:element name="foaf:Organization">	
					<xsl:attribute name="rdf:about"><xsl:value-of select="$focus"/></xsl:attribute>
					<xsl:element name="rdf:type">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($foaf, 'Agent')"/></xsl:attribute>
					</xsl:element>
					<xsl:element name="rdf:type">
						<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($dcterms, 'Agent')"/></xsl:attribute>
					</xsl:element>
					<xsl:apply-templates mode="organisation"/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="controlaccess/corpname/emph[@altrender='a']" mode="concept">
	<xsl:element namespace="{$def}" name="name"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/corpname/emph[@altrender='a']" mode="organisation">
	<xsl:element name="rdfs:label"><xsl:value-of select="normalize-space(.)"/></xsl:element>
	<xsl:element name="foaf:name"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/corpname/emph[@altrender='y']" mode="concept">
	<xsl:element namespace="{$def}" name="dates"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/corpname/emph[@altrender='y']" mode="organisation">
	<xsl:element namespace="{$def}" name="dates"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/corpname/emph[@altrender='z']" mode="concept">
	<xsl:element namespace="{$def}" name="location"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/corpname/emph[@altrender='z']" mode="organisation">
	<xsl:element namespace="{$def}" name="location"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/corpname/emph[@altrender='x']" mode="concept">
	<xsl:element namespace="{$def}" name="other"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/corpname/emph[@altrender='x']" mode="organisation">
	<xsl:element namespace="{$def}" name="other"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/geogname">

	<xsl:variable name="slug">
		<xsl:call-template name="slugify">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="emph[@altrender]">
						<xsl:for-each select="emph[@altrender]">
							<xsl:value-of select="normalize-space(.)"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space(.)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="prefix">
		<xsl:choose>
			<xsl:when test="@source">
				<xsl:value-of select="normalize-space(@source)"/>
			</xsl:when>
			<xsl:when test="@rules">
				<xsl:value-of select="normalize-space(@rules)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$repositoryid"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="label">
		<xsl:choose>
			<xsl:when test="emph[@altrender]">
				<xsl:for-each select="emph[@altrender]">
					<xsl:value-of select="normalize-space(.)"/>
					<xsl:if test="not(position() = last())">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space(.)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="concept"><xsl:value-of select="concat($id, 'concept/place/', $prefix, '/', $slug)"/></xsl:variable>

	<xsl:variable name="focus"><xsl:value-of select="concat($id, 'place/', $prefix, '/', $slug)"/></xsl:variable>
	
	<xsl:element namespace="{$def}" name="associatedWith">
		<xsl:comment>About the Concept (Place)</xsl:comment> 
		<xsl:element name="skos:Concept">
			<xsl:attribute name="rdf:about"><xsl:value-of select="$concept"/></xsl:attribute>

			<xsl:element name="rdfs:label"><xsl:value-of select="$label"/></xsl:element>
<!--			<xsl:element name="skos:prefLabel"><xsl:value-of select="$label"/></xsl:element> -->

			<xsl:apply-templates mode="concept"/>

			<xsl:element name="skos:inScheme">
				<xsl:element name="skos:ConceptScheme">
					<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'conceptscheme/', $prefix)"/></xsl:attribute>
					<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$prefix"/></xsl:element>
				</xsl:element>
			</xsl:element>

			<xsl:element name="foaf:focus">
				<xsl:comment>About the Place</xsl:comment> 
				<xsl:element name="wgs84_pos:SpatialThing">	
					<xsl:attribute name="rdf:about"><xsl:value-of select="$focus"/></xsl:attribute>
					<xsl:apply-templates mode="place"/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="controlaccess/geogname/emph[@altrender='a']" mode="concept">
	<xsl:element namespace="{$def}" name="name"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/geogname/emph[@altrender='a']" mode="place">
	<xsl:element name="rdfs:label"><xsl:value-of select="normalize-space(.)"/></xsl:element>
	<xsl:element namespace="{$def}" name="name"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/geogname/emph[@altrender='location']" mode="concept">
	<xsl:element namespace="{$def}" name="name"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/geogname/emph[@altrender='location']" mode="place">
	<xsl:element name="rdfs:label"><xsl:value-of select="normalize-space(.)"/></xsl:element>
	<xsl:element namespace="{$def}" name="name"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<!-- concept only? -->
<xsl:template match="controlaccess/geogname/emph[@altrender='y']" mode="concept">
	<xsl:element namespace="{$def}" name="dates"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/geogname/emph[@altrender='z']" mode="concept">
	<xsl:element namespace="{$def}" name="location"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/geogname/emph[@altrender='z']" mode="place">
	<xsl:element namespace="{$def}" name="location"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/geogname/emph[@altrender='x']" mode="concept">
	<xsl:element namespace="{$def}" name="other"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/geogname/emph[@altrender='x']" mode="place">
	<xsl:element namespace="{$def}" name="other"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/genreform">

	<xsl:variable name="slug">
		<xsl:call-template name="slugify">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="emph[@altrender]">
						<xsl:for-each select="emph[@altrender]">
							<xsl:value-of select="normalize-space(.)"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space(.)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="prefix">
		<xsl:choose>
			<xsl:when test="@source">
				<xsl:value-of select="normalize-space(@source)"/>
			</xsl:when>
			<xsl:when test="@rules">
				<xsl:value-of select="normalize-space(@rules)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$repositoryid"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="label">
		<xsl:choose>
			<xsl:when test="emph[@altrender]">
				<xsl:for-each select="emph[@altrender]">
					<xsl:value-of select="normalize-space(.)"/>
					<xsl:if test="not(position() = last())">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space(.)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="concept"><xsl:value-of select="concat($id, 'concept/', $prefix, '/', $slug)"/></xsl:variable>
	
	<xsl:element namespace="{$def}" name="associatedWith">
		<xsl:comment>About the Concept (Genre/Form)</xsl:comment> 
		<xsl:element name="skos:Concept">
			<xsl:attribute name="rdf:about"><xsl:value-of select="$concept"/></xsl:attribute>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($def, 'GenreForm')"/></xsl:attribute>
			</xsl:element>

			<xsl:element name="rdfs:label"><xsl:value-of select="$label"/></xsl:element>
<!--			<xsl:element name="skos:prefLabel"><xsl:value-of select="$label"/></xsl:element> -->

			<xsl:apply-templates/>

			<xsl:element name="skos:inScheme">
				<xsl:element name="skos:ConceptScheme">
					<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'conceptscheme/', $prefix)"/></xsl:attribute>
					<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$prefix"/></xsl:element>
				</xsl:element>
			</xsl:element>
			
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="controlaccess/genreform/emph[@altrender='genre']">
	<xsl:element name="rdfs:label"><xsl:value-of select="normalize-space(.)"/></xsl:element>
	<xsl:element name="skos:prefLabel"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/function">

	<xsl:variable name="slug">
		<xsl:call-template name="slugify">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="emph[@altrender]">
						<xsl:for-each select="emph[@altrender]">
							<xsl:value-of select="normalize-space(.)"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space(.)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="prefix">
		<xsl:choose>
			<xsl:when test="@source">
				<xsl:value-of select="normalize-space(@source)"/>
			</xsl:when>
			<xsl:when test="@rules">
				<xsl:value-of select="normalize-space(@rules)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$repositoryid"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="label">
		<xsl:choose>
			<xsl:when test="emph[@altrender]">
				<xsl:for-each select="emph[@altrender]">
					<xsl:value-of select="normalize-space(.)"/>
					<xsl:if test="not(position() = last())">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space(.)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="concept"><xsl:value-of select="concat($id, 'concept/', $prefix, '/', $slug)"/></xsl:variable>

	<xsl:element namespace="{$def}" name="associatedWith">
		<xsl:comment>About the Concept (Function)</xsl:comment> 
		<xsl:element name="skos:Concept">
			<xsl:attribute name="rdf:about"><xsl:value-of select="$concept"/></xsl:attribute>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($def, 'Function')"/></xsl:attribute>
			</xsl:element>

			<xsl:element name="rdfs:label"><xsl:value-of select="$label"/></xsl:element>
<!--			<xsl:element name="skos:prefLabel"><xsl:value-of select="$label"/></xsl:element> -->

			<xsl:apply-templates/>

			<xsl:element name="skos:inScheme">
				<xsl:element name="skos:ConceptScheme">
					<xsl:attribute name="rdf:about"><xsl:value-of select="concat($id, 'conceptscheme/', $prefix)"/></xsl:attribute>
					<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$prefix"/></xsl:element>
				</xsl:element>
			</xsl:element>

		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="controlaccess/function/emph[@altrender='a']">
	<xsl:element name="rdfs:label"><xsl:value-of select="normalize-space(.)"/></xsl:element>
	<xsl:element name="skos:prefLabel"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template match="controlaccess/title">

	<xsl:variable name="slug">
		<xsl:call-template name="slugify">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="emph[@altrender]">
						<xsl:for-each select="emph[@altrender]">
							<xsl:value-of select="normalize-space(.)"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space(.)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="prefix">
		<xsl:choose>
			<xsl:when test="@source">
				<xsl:value-of select="normalize-space(@source)"/>
			</xsl:when>
			<xsl:when test="@rules">
				<xsl:value-of select="normalize-space(@rules)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$repositoryid"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="label">
		<xsl:choose>
			<xsl:when test="emph[@altrender]">
				<xsl:for-each select="emph[@altrender]">
					<xsl:value-of select="normalize-space(.)"/>
					<xsl:if test="not(position() = last())">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space(.)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="document"><xsl:value-of select="concat($id, 'document/', $prefix, '/', $slug)"/></xsl:variable>

	<xsl:element namespace="{$def}" name="associatedWith">
		<xsl:element name="foaf:Document">
			<xsl:attribute name="rdf:about"><xsl:value-of select="$document"/></xsl:attribute>
			<xsl:element name="rdf:type">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bibo, 'Document')"/></xsl:attribute>
			</xsl:element>

			<xsl:element name="rdfs:label"><xsl:value-of select="$label"/></xsl:element>
<!--			<xsl:element name="skos:prefLabel"><xsl:value-of select="$label"/></xsl:element> -->
			<xsl:element name="dcterms:title"><xsl:value-of select="$label"/></xsl:element>

			<xsl:apply-templates/>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="controlaccess/title/emph[@altrender='a']">
	<xsl:element name="rdfs:label"><xsl:value-of select="normalize-space(.)"/></xsl:element>
<!--	<xsl:element name="skos:prefLabel"><xsl:value-of select="normalize-space(.)"/></xsl:element> -->
	<xsl:element name="dcterms:title"><xsl:value-of select="normalize-space(.)"/></xsl:element>
</xsl:template>

<xsl:template name="make-life-events">
<xsl:param name="person"/>
<xsl:param name="label"/>
<xsl:param name="indates"/>

	<xsl:choose>
	<!-- Test for yyyymmdd/yyyymmdd with mm, dd optional -->
	<xsl:when test="matches($indates, '^[1-9]\d{3}(((0[1-9])|(1[0-2]))((0[1-9])|([1-2]\d)|(3[0-1]))?)?/[1-9]\d{3}(((0[1-9])|(1[0-2]))((0[1-9])|([1-2]\d)|(3[0-1]))?)?$')">	
	<!-- i.e. birth/death -->

		<xsl:variable name="dates" select="tokenize($indates, '/')"/>
		
		<xsl:variable name="startdate" select="$dates[1]"/>
		<xsl:variable name="enddate" select="$dates[2]"/>

		<xsl:element namespace="{$def}" name="dateBirth">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$startdate"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element namespace="{$def}" name="dateDeath">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$enddate"/>
			</xsl:call-template>
		</xsl:element>
				
		<xsl:element name="bio:event">
			<xsl:call-template name="make-birth-event">
				<xsl:with-param name="person" select="$person"/>
				<xsl:with-param name="label" select="$label"/>
				<xsl:with-param name="date" select="$startdate"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="event:agent_in">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'birth')"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="crm:P98i_was_born">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'birth')"/>
			</xsl:attribute>
		</xsl:element>

		<xsl:element name="bio:event">
			<xsl:call-template name="make-death-event">
				<xsl:with-param name="person" select="$person"/>
				<xsl:with-param name="label" select="$label"/>
				<xsl:with-param name="date" select="$enddate"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="event:agent_in">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'death')"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="crm:P100i_died_in">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'death')"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:when>
	<!-- Test for yyyymmdd with mm, dd optional -->
	<xsl:when test="matches($indates, '^[1-9]\d{3}(((0[1-9])|(1[0-2]))((0[1-9])|([1-2]\d)|(3[0-1]))?)?$')">	
	<!-- i.e. birth only -->

		<xsl:variable name="startdate" select="$indates"/>

		<xsl:element namespace="{$def}" name="dateBirth">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$startdate"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="bio:event">
			<xsl:call-template name="make-birth-event">
				<xsl:with-param name="person" select="$person"/>
				<xsl:with-param name="label" select="$label"/>
				<xsl:with-param name="date" select="$startdate"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="event:agent_in">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'birth')"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="crm:P98i_was_born">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'birth')"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:when>
	<xsl:when test="matches($indates, '^b[1-9]\d{3}(((0[1-9])|(1[0-2]))((0[1-9])|([1-2]\d)|(3[0-1]))?)?')">
	<!-- i.e. birth only -->
		<xsl:variable name="startdate" select="substring-after($indates, 'b')"/>
		<xsl:element namespace="{$def}" name="dateBirth">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$startdate"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="bio:event">
			<xsl:call-template name="make-birth-event">
				<xsl:with-param name="person" select="$person"/>
				<xsl:with-param name="label" select="$label"/>
				<xsl:with-param name="date" select="$startdate"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="event:agent_in">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'birth')"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="crm:P98i_was_born">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'birth')"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:when>
	<xsl:when test="matches($indates, '^d[1-9]\d{3}(((0[1-9])|(1[0-2]))((0[1-9])|([1-2]\d)|(3[0-1]))?)?')">
	<!-- i.e. death only -->
		<xsl:variable name="enddate" select="substring-after($indates, 'd')"/>
		<xsl:element namespace="{$def}" name="dateDeath">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$enddate"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="bio:event">
			<xsl:call-template name="make-death-event">
				<xsl:with-param name="person" select="$person"/>
				<xsl:with-param name="label" select="$label"/>
				<xsl:with-param name="date" select="$enddate"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="event:agent_in">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'death')"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="crm:P100i_died_in">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'death')"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:when>
	<xsl:when test="matches($indates, '^fl[1-9]\d{3}(((0[1-9])|(1[0-2]))((0[1-9])|([1-2]\d)|(3[0-1]))?)?(/[1-9]\d{3}(((0[1-9])|(1[0-2]))((0[1-9])|([1-2]\d)|(3[0-1]))?)?)?$')">	
	<!-- i.e. floruit single date or floruit date range-->
		<xsl:variable name="dates" select="tokenize(substring-after($indates, 'fl'), '/')"/>

		<xsl:choose>
			<xsl:when test="count($dates) = 2">
				<xsl:variable name="startdate" select="$dates[1]"/>
				<xsl:variable name="enddate" select="$dates[2]"/>
				
				<xsl:element name="bio:event">
					<xsl:call-template name="make-floruit-event-period">
						<xsl:with-param name="person" select="$person"/>
						<xsl:with-param name="label" select="$label"/>
						<xsl:with-param name="startdate" select="$startdate"/>
						<xsl:with-param name="enddate" select="$enddate"/>
					</xsl:call-template>
				</xsl:element>
				<xsl:element name="event:agent_in">
					<xsl:attribute name="rdf:resource">
						<xsl:value-of select="replace($person, 'person', 'floruit')"/>
					</xsl:attribute>
				</xsl:element>
			</xsl:when>
			<xsl:when test="count($dates) = 1">
				<xsl:variable name="startdate" select="$dates[1]"/>
				<xsl:element name="bio:event">
					<xsl:call-template name="make-floruit-event-date">
						<xsl:with-param name="person" select="$person"/>
						<xsl:with-param name="label" select="$label"/>
						<xsl:with-param name="date" select="$startdate"/>
					</xsl:call-template>
				</xsl:element>
				<xsl:element name="event:agent_in">
					<xsl:attribute name="rdf:resource">
						<xsl:value-of select="replace($person, 'person', 'floruit')"/>
					</xsl:attribute>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>

	</xsl:when>
	</xsl:choose>

</xsl:template>

<xsl:template name="make-birth-event">
<xsl:param name="person"/>
<xsl:param name="label"/>
<xsl:param name="date"/>

	<xsl:comment>About the Birth (Event)</xsl:comment> 
	<xsl:element name="bio:Birth">
		<xsl:attribute name="rdf:about"><xsl:value-of select="replace($person, 'person', 'birth')"/></xsl:attribute>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bio, 'IndividualEvent')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bio, 'Event')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($lode, 'Event')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($event, 'Event')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($crm, 'E67_Birth')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="concat('Birth of ', $label)"/></xsl:element>
		<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="concat('Birth of ', $label)"/></xsl:element>
		<xsl:element name="bio:date">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$date"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="dcterms:date">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$date"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="event:time">
			<xsl:call-template name="make-interval-during-date">
				<xsl:with-param name="uri" select="replace($person, 'person', 'birthtime')"/>
				<xsl:with-param name="label" select="concat('Time of Birth of ', $label)"/>
				<xsl:with-param name="date" select="$date"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="lode:atTime">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'birthtime')"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="crm:P4_has_time-span">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'birthtime')"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="bio:principal">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="bio:agent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="lode:involvedAgent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="event:agent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="crm:P98_brought_into_life">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
	</xsl:element>

</xsl:template>

<xsl:template name="make-death-event">
<xsl:param name="person"/>
<xsl:param name="label"/>
<xsl:param name="date"/>

	<xsl:comment>About the Death (Event)</xsl:comment> 
	<xsl:element name="bio:Death">
		<xsl:attribute name="rdf:about"><xsl:value-of select="replace($person, 'person', 'death')"/></xsl:attribute>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bio, 'IndividualEvent')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bio, 'Event')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($lode, 'Event')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($event, 'Event')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($crm, 'E69_Death')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="concat('Death of ', $label)"/></xsl:element>
		<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="concat('Death of ', $label)"/></xsl:element>
		<xsl:element name="bio:date">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$date"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="dcterms:date">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$date"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="event:time">
			<xsl:call-template name="make-interval-during-date">
				<xsl:with-param name="uri" select="replace($person, 'person', 'deathtime')"/>
				<xsl:with-param name="label" select="concat('Time of Death of ', $label)"/>
				<xsl:with-param name="date" select="$date"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="lode:atTime">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'deathtime')"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="crm:P4_has_time-span">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'deathtime')"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="bio:principal">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="bio:agent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="lode:involvedAgent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="event:agent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="crm:P100_was_death_of">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
	</xsl:element>

</xsl:template>

<xsl:template name="make-floruit-event-period">
<xsl:param name="person"/>
<xsl:param name="label"/>
<xsl:param name="startdate"/>
<xsl:param name="enddate"/>
	
	<xsl:comment>About the "Flourishing" (Event)</xsl:comment> 
	<xsl:element namespace="{$def}" name="Floruit">
		<xsl:attribute name="rdf:about"><xsl:value-of select="replace($person, 'person', 'floruit')"/></xsl:attribute>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bio, 'IndividualEvent')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bio, 'Event')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($lode, 'Event')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($event, 'Event')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="concat('Floruit of ', $label)"/></xsl:element>
		<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="concat('Floruit of ', $label)"/></xsl:element>
		<xsl:element name="event:time">
			<xsl:call-template name="make-interval-as-range">
				<xsl:with-param name="uri" select="replace($person, 'person', 'floruittime')"/>
				<xsl:with-param name="label" select="concat('Time of Floruit of ', $label)"/>
				<xsl:with-param name="startdate" select="$startdate"/>
				<xsl:with-param name="enddate" select="$enddate"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="lode:atTime">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'floruittime')"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="bio:principal">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="bio:agent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="lode:involvedAgent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="event:agent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
	</xsl:element>

</xsl:template>

<xsl:template name="make-floruit-event-date">
<xsl:param name="person"/>
<xsl:param name="label"/>
<xsl:param name="date"/>

	<xsl:comment>About the "Flourishing" (Event)</xsl:comment> 
	<xsl:element namespace="{$def}" name="Floruit">
		<xsl:attribute name="rdf:about"><xsl:value-of select="replace($person, 'person', 'floruit')"/></xsl:attribute>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bio, 'IndividualEvent')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bio, 'Event')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($lode, 'Event')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($event, 'Event')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="concat('Floruit of ', $label)"/></xsl:element>
		<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="concat('Floruit of ', $label)"/></xsl:element>
		<xsl:element name="bio:date">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$date"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="dcterms:date">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$date"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="event:time">
			<xsl:call-template name="make-interval-containing-date">
				<xsl:with-param name="uri" select="replace($person, 'person', 'floruittime')"/>
				<xsl:with-param name="label" select="concat('Time of Floruit of ', $label)"/>
				<xsl:with-param name="date" select="$date"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="lode:atTime">
			<xsl:attribute name="rdf:resource">
				<xsl:value-of select="replace($person, 'person', 'floruittime')"/>
			</xsl:attribute>
		</xsl:element>
		<xsl:element name="bio:principal">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="bio:agent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="lode:involvedAgent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="event:agent">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="$person"/></xsl:attribute>
		</xsl:element>
	</xsl:element>

</xsl:template>

<xsl:template name="type-date">
<xsl:param name="date"/>

	<xsl:choose>
		<xsl:when test="string-length($date) = 4">
			<xsl:attribute name="rdf:datatype"><xsl:value-of select="concat($xsd, 'gYear')"/></xsl:attribute>
			<xsl:value-of select="$date"/>
		</xsl:when>
		<xsl:when test="string-length($date) = 6">
			<xsl:attribute name="rdf:datatype"><xsl:value-of select="concat($xsd, 'gYearMonth')"/></xsl:attribute>
			<xsl:value-of select="concat(substring($date, 1, 4), '-', substring($date, 5, 2))"/>
		</xsl:when>
		<xsl:when test="string-length($date) = 8">
			<xsl:attribute name="rdf:datatype"><xsl:value-of select="concat($xsd, 'date')"/></xsl:attribute>
			<xsl:value-of select="concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2))"/>
		</xsl:when>
	</xsl:choose>

</xsl:template>

<xsl:template name="make-refgov-date-uri">
<xsl:param name="date"/>

	<xsl:choose>
		<xsl:when test="string-length($date) = 4">
			<xsl:value-of select="concat($ref, 'year/', $date)"/>
		</xsl:when>
		<xsl:when test="string-length($date) = 6">
			<xsl:value-of select="concat($ref, 'month/', substring($date, 1, 4), '-', substring($date, 5, 2))"/>
		</xsl:when>
		<xsl:when test="string-length($date) = 8">
			<xsl:value-of select="concat($ref, 'day/', substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2))"/>
		</xsl:when>
	</xsl:choose>

</xsl:template>


<xsl:template name="make-interval-as-range">
<xsl:param name="uri"/>
<xsl:param name="label"/>
<xsl:param name="startdate"/>
<xsl:param name="enddate"/>

	<xsl:comment>About the Time Interval</xsl:comment> 
	<xsl:element name="time:Interval">
		<xsl:attribute name="rdf:about"><xsl:value-of select="$uri"/></xsl:attribute>
		<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element>
		<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element>
		<xsl:element name="timeline:timeline">
			<xsl:element name="timeline:TimeLine">
				<xsl:attribute name="rdf:about"><xsl:value-of select="concat($timeline, 'universaltimeline')"/></xsl:attribute>
			</xsl:element>
		</xsl:element>
		<xsl:element name="timeline:start">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$startdate"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="time:intervalStarts">
			<xsl:element name="time:Interval">
				<xsl:attribute name="rdf:about">
					<xsl:call-template name="make-refgov-date-uri">
						<xsl:with-param name="date" select="$startdate"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
		</xsl:element>
		<xsl:element name="crm:P86i_contains">
			<xsl:element name="crm:E52_Time-Span">
				<xsl:attribute name="rdf:about">
					<xsl:call-template name="make-refgov-date-uri">
						<xsl:with-param name="date" select="$startdate"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
		</xsl:element>
		<xsl:element name="timeline:end">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$enddate"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="time:intervalEnds">
			<xsl:element name="time:Interval">
				<xsl:attribute name="rdf:about">
					<xsl:call-template name="make-refgov-date-uri">
						<xsl:with-param name="date" select="$enddate"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
		</xsl:element>
		<xsl:element name="crm:P86i_contains">
			<xsl:element name="crm:E52_Time-Span">
				<xsl:attribute name="rdf:about">
					<xsl:call-template name="make-refgov-date-uri">
						<xsl:with-param name="date" select="$enddate"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
		</xsl:element>
	</xsl:element>

</xsl:template>

<xsl:template name="make-interval-during-date">
<xsl:param name="uri"/>
<xsl:param name="label"/>
<xsl:param name="date"/>
	
	<xsl:comment>About the Time Interval</xsl:comment> 
	<xsl:element name="time:Interval">
		<xsl:attribute name="rdf:about"><xsl:value-of select="$uri"/></xsl:attribute>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($crm, 'E52_Time-Span')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element>
		<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element>
		<xsl:element name="timeline:timeline">
			<xsl:element name="timeline:TimeLine">
				<xsl:attribute name="rdf:about"><xsl:value-of select="concat($timeline, 'universaltimeline')"/></xsl:attribute>
			</xsl:element>
		</xsl:element>
		<!-- Not sure about using tl:at for a "during" relation? -->
		<xsl:comment>Not sure about use of timeline:at for a "during" relation?</xsl:comment> 
		<xsl:element name="timeline:at">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$date"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="time:intervalDuring">
			<xsl:element name="time:Interval">
				<xsl:attribute name="rdf:about">
					<xsl:call-template name="make-refgov-date-uri">
						<xsl:with-param name="date" select="$date"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
		</xsl:element>
		<xsl:element name="crm:P86_falls_within">
			<xsl:element name="crm:E52_Time-Span">
				<xsl:attribute name="rdf:about">
					<xsl:call-template name="make-refgov-date-uri">
						<xsl:with-param name="date" select="$date"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
		</xsl:element>
	</xsl:element>

</xsl:template>

<xsl:template name="make-interval-containing-date">
<xsl:param name="uri"/>
<xsl:param name="label"/>
<xsl:param name="date"/>
	
	<xsl:comment>About the Time Interval</xsl:comment> 
	<xsl:element name="time:Interval">
		<xsl:attribute name="rdf:about"><xsl:value-of select="$uri"/></xsl:attribute>
		<xsl:element name="rdf:type">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="concat($crm, 'E52_Time-Span')"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="rdfs:label"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element>
		<xsl:element name="skos:prefLabel"><xsl:attribute name="xml:lang">en</xsl:attribute><xsl:value-of select="$label"/></xsl:element>
		<xsl:element name="timeline:timeline">
			<xsl:element name="timeline:TimeLine">
				<xsl:attribute name="rdf:about"><xsl:value-of select="concat($timeline, 'universaltimeline')"/></xsl:attribute>
			</xsl:element>
		</xsl:element>
		<!-- Not sure about using timeline:at for a "contains" relation? -->
		<xsl:comment>Not sure about use of timeline:at for a "contains" relation?</xsl:comment> 
		<xsl:element name="timeline:at">
			<xsl:call-template name="type-date">
				<xsl:with-param name="date" select="$date"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="time:intervalContains">
			<xsl:element name="time:Interval">
				<xsl:attribute name="rdf:about">
					<xsl:call-template name="make-refgov-date-uri">
						<xsl:with-param name="date" select="$date"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
		</xsl:element>
		<xsl:element name="crm:P86i_contains">
			<xsl:element name="crm:E52_Time-Span">
				<xsl:attribute name="rdf:about">
					<xsl:call-template name="make-refgov-date-uri">
						<xsl:with-param name="date" select="$date"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
		</xsl:element>
	</xsl:element>

</xsl:template>


<xsl:template name="slugify">
<xsl:param name="text"/>
<!-- Translates text into URI slug - strips all reserved RFC3986 chars (and some other punctuation) to avoid %-encoding --> 
	<xsl:variable name="stripped-of-quotes" select="translate(lower-case(normalize-space($text)), '&quot;', '')"/>
	<xsl:value-of select="translate($stripped-of-quotes, &quot; :\/?#`[]@!$&amp;'()*+,;=.|&quot;, &quot;&quot;)"/>
</xsl:template>


<xsl:template name="hubify">
<xsl:param name="text"/>
<!-- Translates eadid/unitid into URI path using the rules http://archiveshub.ac.uk/linkingtodescriptions/ --> 
	<xsl:value-of select="encode-for-uri(translate(lower-case(normalize-space($text)),'\/, ', '--' ))"/>
</xsl:template>

<xsl:template match="text()|@*">
</xsl:template>

<xsl:template match="text()|@*" mode="concept">
</xsl:template>

<xsl:template match="text()|@*" mode="person">
</xsl:template>

<xsl:template match="text()|@*" mode="family">
</xsl:template>

<xsl:template match="text()|@*" mode="organisation">
</xsl:template>

<xsl:template match="text()|@*" mode="place">
</xsl:template>

</xsl:stylesheet>