<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="/People">
    <People>
      <xsl:for-each select="Person">
        <xsl:variable name="genderTag" select="Gender" />
        <xsl:element name="{concat('', $genderTag)}">
          <xsl:call-template name="Person">
            <xsl:with-param name="personGenderValue" />
          </xsl:call-template>
        </xsl:element>
      </xsl:for-each>
    </People>
  </xsl:template>
  <xsl:template name="Person">
    <xsl:param name="personGenderValue" />
    <Name>
      <xsl:value-of select="concat(Name/First,' ',Name/Last)" />
    </Name>
    <Gender>
      <xsl:call-template name="genderMapping">
        <xsl:with-param name="genderValue" select="Gender" />
      </xsl:call-template>
    </Gender>
    <SSN>
      <xsl:value-of select="SSN" />
    </SSN>
  </xsl:template>
  <xsl:template name="genderMapping">
    <xsl:param name="genderValue" />
    <xsl:choose>
      <xsl:when test="$genderValue='Female'">
        <xsl:text>F</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>M</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

