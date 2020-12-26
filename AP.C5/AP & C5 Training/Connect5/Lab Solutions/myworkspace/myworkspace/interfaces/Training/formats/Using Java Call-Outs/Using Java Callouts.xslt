<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xalan/java" exclude-result-prefixes="java" version="1.0">
  <xsl:template match="/People">
    <People>
      <xsl:for-each select="Person">
        <xsl:choose>
          <xsl:when test="Gender='Female'">
            <Female>
              <FullName>
                <xsl:value-of select="concat(Name/First,' ',Name/Last)" />
              </FullName>
              <GUID>
                <xsl:value-of select="java:java.util.UUID.randomUUID( )" />
              </GUID>
            </Female>
          </xsl:when>
          <xsl:otherwise>
            <Male>
              <FullName>
                <xsl:value-of select="concat(Name/First,' ',Name/Last)" />
              </FullName>
              <GUID>
                <xsl:value-of select="java:java.util.UUID.randomUUID( )" />
              </GUID>
            </Male>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </People>
  </xsl:template>
</xsl:stylesheet>

