<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="/People">
    <People>
      <xsl:for-each select="Person" />
      <Person>
        <Name>
          <First>
            <xsl:value-of select="Person/Name/First" />
          </First>
          <Middle>
            <xsl:value-of select="Person/Name/Middle" />
          </Middle>
          <Last>
            <xsl:value-of select="Person/Name/Last" />
          </Last>
        </Name>
        <Gender>
          <xsl:value-of select="Person/Gender" />
        </Gender>
        <SSN>
          <xsl:value-of select="Person/SSN" />
        </SSN>
        <BirthDate>
          <xsl:value-of select="Person/BirthDate" />
        </BirthDate>
        <Occupation>
          <xsl:value-of select="Person/Occupation" />
        </Occupation>
      </Person>
    </People>
  </xsl:template>
</xsl:stylesheet>

