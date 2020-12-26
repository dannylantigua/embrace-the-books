<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="/People">
    <People>
      <xsl:for-each select="Person">
        <xsl:sort select="Name/Last" />
        <Person>
          <Name>
            <First>
              <xsl:value-of select="Name/First" />
            </First>
            <Middle>
              <xsl:value-of select="Name/Middle" />
            </Middle>
            <Last>
              <xsl:value-of select="Name/Last" />
            </Last>
          </Name>
          <Gender>
            <xsl:value-of select="Gender" />
          </Gender>
          <SSN>
            <xsl:value-of select="SSN" />
          </SSN>
          <BirthDate>
            <xsl:value-of select="BirthDate" />
          </BirthDate>
          <Occupation>
            <xsl:value-of select="Occupation" />
          </Occupation>
        </Person>
      </xsl:for-each>
    </People>
  </xsl:template>
</xsl:stylesheet>

