//
//  Shader.fsh
//  test
//
//  Created by Kanaya Fumihiro on 11/01/31.
//  Copyright 2011 Skip co,.Ltd. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
