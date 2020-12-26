<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="/People">
    <People>
      <xsl:for-each select="Person">
        <xsl:variable name="uniqueId" select="generate-id()" />
        <xsl:choose>
          <xsl:when test="Gender='Female'">
            <Female>
              <FullName>
                <xsl:value-of select="concat(Name/First,' ',Name/Last)" />
              </FullName>
              <Neighbors>
                <xsl:variable name="currentState" select="Address/State" />
                <xsl:for-each select="../Person">
                  <xsl:variable name="localId" select="generate-id()" />
                  <xsl:if test="$currentState=Address/State and $uniqueId!=$localId">
                    <Neighbor>
                      <xsl:value-of select="concat(Name/First,' ',Name/Last)" />
                    </Neighbor>
                  </xsl:if>
                </xsl:for-each>
              </Neighbors>
            </Female>
          </xsl:when>
          <xsl:otherwise>
            <Male>
              <FullName>
                <xsl:value-of select="concat(Name/First,' ',Name/Last)" />
              </FullName>
              <Neighbors>
                <xsl:variable name="currentState" select="Address/State" />
                <xsl:for-each select="../Person">
                  <xsl:variable name="localId" select="generate-id()" />
                  <xsl:if test="$currentState=Address/State and $uniqueId!=$localId">
                    <Neighbor>
                      <xsl:value-of select="concat(Name/First,' ',Name/Last)" />
                    </Neighbor>
                  </xsl:if>
                </xsl:for-each>
              </Neighbors>
            </Male>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </People>
  </xsl:template>
</xsl:stylesheet>

