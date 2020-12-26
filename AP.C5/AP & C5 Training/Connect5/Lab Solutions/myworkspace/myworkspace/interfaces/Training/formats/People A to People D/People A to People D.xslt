<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="/People">
    <People>
      <xsl:for-each select="Person">
        <xsl:choose>
          <xsl:when test="Gender='Female'">
            <Female>
              <FullName>
                <xsl:value-of select="concat(Name/First,' ',Name/Middle,' ',Name/Last)" />
              </FullName>
              <SSN>
                <xsl:value-of select="SSN" />
              </SSN>
              <BirthDate>
                <xsl:value-of select="BirthDate" />
              </BirthDate>
              <Occupation>
                <xsl:value-of select="Occupation" />
              </Occupation>
            </Female>
          </xsl:when>
          <xsl:otherwise>
            <Male>
              <FullName>
                <xsl:value-of select="concat(Name/First,' ',Name/Middle,' ',Name/Last)" />
              </FullName>
              <SSN>
                <xsl:value-of select="SSN" />
              </SSN>
              <BirthDate>
                <xsl:value-of select="BirthDate" />
              </BirthDate>
              <Occupation>
                <xsl:value-of select="Occupation" />
              </Occupation>
            </Male>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </People>
  </xsl:template>
</xsl:stylesheet>

